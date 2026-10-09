
import json
from datetime import datetime, timezone

import psycopg
from psycopg.types.json import Jsonb
from kafka import KafkaConsumer

KAFKA_TOPIC = "aviation.aircraft.states"

DB_CONFIG = {
    "host": "localhost",
    "port": 5433,
    "dbname": "aviation_stream",
    "user": "aviation_user",
    "password": "aviation_dev_password",
}

JOB_NAME = "opensky_kafka_to_postgres"
SOURCE_NAME = "OpenSky Network"
TARGET_TABLE = "staging.stg_aircraft_iot_stream"


def get_datetime(value):
    if not value:
        return None

    result = datetime.fromisoformat(value.replace("Z", "+00:00"))

    if result.tzinfo is None:
        result = result.replace(tzinfo=timezone.utc)

    return result


def setup_database():
    with psycopg.connect(**DB_CONFIG) as conn:
        conn.execute("CREATE SCHEMA IF NOT EXISTS staging")
        conn.execute("CREATE SCHEMA IF NOT EXISTS audit")

        conn.execute("""
            CREATE TABLE IF NOT EXISTS staging.stg_aircraft_iot_stream (
                record_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                icao24 TEXT NOT NULL,
                callsign TEXT,
                origin_country TEXT,
                longitude DOUBLE PRECISION,
                latitude DOUBLE PRECISION,
                baro_altitude DOUBLE PRECISION,
                velocity DOUBLE PRECISION,
                true_track DOUBLE PRECISION,
                on_ground BOOLEAN,
                event_time TIMESTAMPTZ,
                ingested_at TIMESTAMPTZ NOT NULL,
                payload JSONB NOT NULL,
                UNIQUE (icao24, event_time)
            )
        """)

        conn.execute("""
            CREATE TABLE IF NOT EXISTS audit.etl_execution_log (
                execution_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                job_name VARCHAR(100) NOT NULL,
                source_name VARCHAR(100),
                target_table VARCHAR(150),
                start_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                end_time TIMESTAMPTZ,
                records_read BIGINT NOT NULL DEFAULT 0,
                records_inserted BIGINT NOT NULL DEFAULT 0,
                records_rejected BIGINT NOT NULL DEFAULT 0,
                status VARCHAR(20) NOT NULL DEFAULT 'RUNNING',
                error_message TEXT
            )
        """)

        conn.execute("""
            CREATE TABLE IF NOT EXISTS audit.etl_error_log (
                error_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                execution_id BIGINT
                    REFERENCES audit.etl_execution_log(execution_id),
                source_name VARCHAR(100),
                target_table VARCHAR(150),
                error_type VARCHAR(100) NOT NULL,
                error_message TEXT,
                raw_record JSONB,
                created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
            )
        """)


def start_execution():
    with psycopg.connect(**DB_CONFIG) as conn:
        row = conn.execute("""
            INSERT INTO audit.etl_execution_log (
                job_name, source_name, target_table, status
            )
            VALUES (%s, %s, %s, 'RUNNING')
            RETURNING execution_id
        """, (JOB_NAME, SOURCE_NAME, TARGET_TABLE)).fetchone()

        return row[0]


def log_error(execution_id, event, error):
    # Use a separate transaction so the error can be logged
    # even when the main data transaction has failed.
    try:
        with psycopg.connect(**DB_CONFIG) as conn:
            conn.execute("""
                INSERT INTO audit.etl_error_log (
                    execution_id, source_name, target_table,
                    error_type, error_message, raw_record
                )
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (
                execution_id,
                SOURCE_NAME,
                TARGET_TABLE,
                type(error).__name__,
                str(error),
                Jsonb(event) if event is not None else None,
            ))
    except Exception as audit_error:
        print(f"Could not write error log: {audit_error}")


def finish_execution(
    execution_id, records_read, records_inserted,
    records_rejected, status, error_message=None
):
    with psycopg.connect(**DB_CONFIG) as conn:
        conn.execute("""
            UPDATE audit.etl_execution_log
            SET end_time = NOW(),
                records_read = %s,
                records_inserted = %s,
                records_rejected = %s,
                status = %s,
                error_message = %s
            WHERE execution_id = %s
        """, (
            records_read,
            records_inserted,
            records_rejected,
            status,
            error_message,
            execution_id,
        ))


def main():
    setup_database()
    execution_id = start_execution()

    records_read = 0
    records_inserted = 0
    records_rejected = 0
    status = "SUCCESS"
    error_message = None
    consumer = None

    try:
        consumer = KafkaConsumer(
            KAFKA_TOPIC,
            bootstrap_servers="localhost:9092",
            group_id="aviation-postgres-consumer",
            auto_offset_reset="earliest",
            enable_auto_commit=False,
            value_deserializer=lambda value: json.loads(
                value.decode("utf-8")
            ),
        )

        print(f"Consumer started. Execution ID: {execution_id}")
        print("Waiting for aircraft messages...")

        for message in consumer:
            event = message.value
            records_read += 1

            try:
                if not event.get("icao24"):
                    raise ValueError("Aircraft identifier icao24 is missing")

                event_time = get_datetime(event.get("event_time"))
                ingested_at = get_datetime(event.get("ingested_at"))

                if ingested_at is None:
                    ingested_at = datetime.now(timezone.utc)

                # Insert the aircraft row and update audit counters
                # in the same PostgreSQL transaction.
                with psycopg.connect(**DB_CONFIG) as conn:
                    cursor = conn.execute("""
                        INSERT INTO staging.stg_aircraft_iot_stream (
                            icao24, callsign, origin_country,
                            longitude, latitude, baro_altitude,
                            velocity, true_track, on_ground,
                            event_time, ingested_at, payload
                        )
                        VALUES (
                            %(icao24)s, %(callsign)s, %(origin_country)s,
                            %(longitude)s, %(latitude)s, %(baro_altitude)s,
                            %(velocity)s, %(true_track)s, %(on_ground)s,
                            %(event_time)s, %(ingested_at)s, %(payload)s
                        )
                        ON CONFLICT (icao24, event_time) DO NOTHING
                    """, {
                        **event,
                        "event_time": event_time,
                        "ingested_at": ingested_at,
                        "payload": Jsonb(event),
                    })

                    inserted_now = cursor.rowcount
                    new_inserted = records_inserted + inserted_now

                    conn.execute("""
                        UPDATE audit.etl_execution_log
                        SET records_read = %s,
                            records_inserted = %s,
                            records_rejected = %s
                        WHERE execution_id = %s
                    """, (
                        records_read,
                        new_inserted,
                        records_rejected,
                        execution_id,
                    ))

                # PostgreSQL committed successfully; now commit Kafka offset.
                consumer.commit()
                records_inserted = new_inserted

                if inserted_now:
                    print(
                        f"INSERTED: {event['icao24']} "
                        f"({event.get('callsign') or 'no callsign'})"
                    )
                else:
                    print(
                        f"DUPLICATE SKIPPED: {event['icao24']}"
                    )

            except Exception as error:
                records_rejected += 1
                status = "FAILED"
                error_message = str(error)

                log_error(execution_id, event, error)

                print(f"Processing failed: {error}")
                print("Stopping consumer; this message was not committed.")
                break

    except KeyboardInterrupt:
        print("\nConsumer stopped by user.")

    except Exception as error:
        status = "FAILED"
        error_message = str(error)
        print(f"Consumer failed: {error}")

    finally:
        if consumer is not None:
            consumer.close()

        try:
            finish_execution(
                execution_id,
                records_read,
                records_inserted,
                records_rejected,
                status,
                error_message,
            )
            print(f"Execution {execution_id} finished with status: {status}")
            print(f"Messages read: {records_read}")
            print(f"New rows inserted: {records_inserted}")
            print(f"Rejected messages: {records_rejected}")
        except Exception as error:
            print(f"Could not finalize execution audit: {error}")


if __name__ == "__main__":
    main()
