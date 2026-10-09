
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

def get_datetime(value):
    if not value:
        return None
    return datetime.fromisoformat(value.replace("Z", "+00:00"))

def main():
    # Create the target table before consuming messages
    with psycopg.connect(**DB_CONFIG) as conn:
        conn.execute("CREATE SCHEMA IF NOT EXISTS staging")

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

    consumer = KafkaConsumer(
        KAFKA_TOPIC,
        bootstrap_servers="localhost:9092",
        group_id="aviation-postgres-consumer",
        auto_offset_reset="earliest",
        enable_auto_commit=False,
        value_deserializer=lambda value: json.loads(value.decode("utf-8")),
    )

    print("Kafka consumer started. Waiting for aircraft messages...")

    try:
        for message in consumer:
            event = message.value

            event_time = get_datetime(event.get("event_time"))
            ingested_at = get_datetime(event.get("ingested_at"))

            if ingested_at is None:
                ingested_at = datetime.now(timezone.utc)

            try:
                with psycopg.connect(**DB_CONFIG) as conn:
                    conn.execute("""
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

                # Commit the Kafka offset only after the DB transaction succeeds
                consumer.commit()
                print(
                    f"Stored {event.get('icao24')} "
                    f"({event.get('callsign') or 'no callsign'})"
                )

            except Exception as error:
                print(f"Database insert failed: {error}")
                print("Stopping consumer to avoid skipping this message.")
                break

    except KeyboardInterrupt:
        print("\nStopping consumer...")

    finally:
        consumer.close()

if __name__ == "__main__":
    main()
