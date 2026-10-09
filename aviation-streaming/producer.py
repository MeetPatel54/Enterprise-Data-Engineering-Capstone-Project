
import json
import time
from datetime import datetime, timezone

import requests
from kafka import KafkaProducer

API_URL = "https://opensky-network.org/api/states/all"

# Approximate geographic area around Chennai and nearby regions
PARAMS = {
    "lamin": 10,
    "lomin": 78,
    "lamax": 14,
    "lomax": 82,
}

KAFKA_TOPIC = "aviation.aircraft.states"

producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    key_serializer=lambda key: key.encode("utf-8"),
    value_serializer=lambda value: json.dumps(value).encode("utf-8"),
    acks="all",
)

def fetch_and_publish():
    print("Requesting aircraft data from OpenSky...")

    response = requests.get(
        API_URL,
        params=PARAMS,
        timeout=30,
    )
    response.raise_for_status()
    result = response.json()

    states = result.get("states") or []
    api_timestamp = result.get("time")

    print(f"Aircraft records received: {len(states)}")

    published = 0

    for state in states:
        # Skip records without an aircraft identifier
        if not state or not state[0]:
            continue

        event = {
            "icao24": state[0],
            "callsign": (state[1] or "").strip() or None,
            "origin_country": state[2],
            "event_time": (
                datetime.fromtimestamp(
                    state[4], tz=timezone.utc
                ).isoformat()
                if state[4] is not None
                else None
            ),
            "longitude": state[5],
            "latitude": state[6],
            "baro_altitude": state[7],
            "on_ground": state[8],
            "velocity": state[9],
            "true_track": state[10],
            "api_timestamp": api_timestamp,
            "ingested_at": datetime.now(timezone.utc).isoformat(),
            "source": "OpenSky Network",
        }

        producer.send(
            KAFKA_TOPIC,
            key=event["icao24"],
            value=event,
        )
        published += 1

    producer.flush()
    print(f"Messages published to Kafka: {published}")


if __name__ == "__main__":
    try:
        while True:
            try:
                fetch_and_publish()
            except (requests.RequestException, ValueError) as error:
                print(f"API request or data error: {error}")
            except Exception as error:
                print(f"Unexpected error: {error}")

            print("Waiting 10 seconds before the next poll...\n")
            time.sleep(10)

    except KeyboardInterrupt:
        print("\nStopping producer...")

    finally:
        producer.close()
