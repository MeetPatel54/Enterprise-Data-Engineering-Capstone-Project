
import requests

url = "https://opensky-network.org/api/states/all"

params = {
    "lamin": 10,
    "lomin": 78,
    "lamax": 14,
    "lomax": 82
}

try:
    response = requests.get(
        url,
        params=params,
        timeout=30
    )

    print("HTTP status:", response.status_code)
    response.raise_for_status()

    data = response.json()
    aircraft = data.get("states") or []

    print("API timestamp:", data.get("time"))
    print("Aircraft received:", len(aircraft))

    for state in aircraft[:5]:
        print({
            "icao24": state[0],
            "callsign": state[1],
            "longitude": state[5],
            "latitude": state[6],
            "altitude": state[7],
            "velocity": state[9]
        })

except requests.RequestException as error:
    print("API request failed:", error)
