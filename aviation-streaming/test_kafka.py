
from kafka import KafkaProducer
import json

producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    value_serializer=lambda value: json.dumps(value).encode("utf-8")
)

producer.send(
    "aviation.aircraft.states",
    {
        "icao24": "test123",
        "callsign": "DEMO001",
        "latitude": 13.0827,
        "longitude": 80.2707,
        "source": "kafka_connection_test"
    }
)

producer.flush()
producer.close()

print("Test message sent to Kafka successfully!")
