-- ================================================================
-- ENTERPRISE AVIATION DATA PLATFORM (EADP)
-- STAR SCHEMA - PostgreSQL DDL
-- ================================================================
-- Warehouse schema contains:
--   7 dimensions
--   7 fact tables
-- Dimensions are loaded before facts because facts contain FK references.
-- ================================================================

CREATE SCHEMA IF NOT EXISTS warehouse;

-- ================================================================
-- 1. DATE DIMENSION
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.dim_date (
    date_key       INTEGER PRIMARY KEY,
    full_date      DATE NOT NULL UNIQUE,
    day            INTEGER,
    month          INTEGER,
    month_name     VARCHAR(20),
    quarter        INTEGER,
    year           INTEGER,
    week_of_year   INTEGER,
    day_of_week    INTEGER,
    day_name       VARCHAR(20)
);

COMMENT ON TABLE warehouse.dim_date IS
'Calendar dimension used for consistent daily, monthly, quarterly and yearly analysis.';

-- ================================================================
-- 2. AIRLINE DIMENSION
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.dim_airline (
    airline_key          SERIAL PRIMARY KEY,
    airline_name         VARCHAR(255) NOT NULL,
    carrier_code         VARCHAR(50),
    unique_carrier       VARCHAR(50),
    unique_carrier_name  VARCHAR(255)
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_airline_name
ON warehouse.dim_airline (airline_name);

-- ================================================================
-- 3. AIRPORT DIMENSION
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.dim_airport (
    airport_key          SERIAL PRIMARY KEY,
    airport_id           VARCHAR(50) NOT NULL UNIQUE,
    airport_name         VARCHAR(255),
    city                 VARCHAR(255),
    state_code           VARCHAR(50),
    state_name           VARCHAR(255),
    country_code         VARCHAR(50),
    region_code          VARCHAR(50),
    icao_id              VARCHAR(50),
    latitude             NUMERIC,
    longitude            NUMERIC,
    elevation            NUMERIC,
    site_type_code       VARCHAR(50),
    ownership_type_code  VARCHAR(50),
    facility_use_code    VARCHAR(50),
    airport_status       VARCHAR(50)
);

-- ================================================================
-- 4. AIRCRAFT DIMENSION
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.dim_aircraft (
    aircraft_key  SERIAL PRIMARY KEY,
    aircraft_id   VARCHAR(100) NOT NULL UNIQUE,
    aircraft_type VARCHAR(100),
    airline       VARCHAR(255)
);

-- ================================================================
-- 5. PASSENGER DIMENSION
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.dim_passenger (
    passenger_key       SERIAL PRIMARY KEY,
    passenger_id        VARCHAR(100),
    customer_id         VARCHAR(100),
    passenger_name      VARCHAR(255),
    age                 INTEGER,
    gender              VARCHAR(50),
    city                VARCHAR(255),
    country             VARCHAR(255),
    email               VARCHAR(255),
    phone               VARCHAR(100),
    loyalty_level       VARCHAR(100),
    customer_since      DATE,
    preferred_channel   VARCHAR(100),
    total_flights       BIGINT,
    total_spend_inr     NUMERIC,
    last_flight_date    DATE,
    loyalty_points      BIGINT,
    marketing_opt_in    VARCHAR(20)
);

CREATE INDEX IF NOT EXISTS ix_dim_passenger_passenger_id
ON warehouse.dim_passenger (passenger_id);

CREATE INDEX IF NOT EXISTS ix_dim_passenger_customer_id
ON warehouse.dim_passenger (customer_id);

-- ================================================================
-- 6. CREW DIMENSION
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.dim_crew (
    crew_key      SERIAL PRIMARY KEY,
    crew_id       VARCHAR(100) NOT NULL UNIQUE,
    crew_name     VARCHAR(255),
    role          VARCHAR(100),
    airline       VARCHAR(255),
    base_airport  VARCHAR(50)
);

-- ================================================================
-- 7. FLIGHT DIMENSION
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.dim_flight (
    flight_key             SERIAL PRIMARY KEY,
    flight_id              VARCHAR(100) NOT NULL UNIQUE,
    flight_number          VARCHAR(100),
    airline_key            INTEGER REFERENCES warehouse.dim_airline(airline_key),
    origin_airport_key     INTEGER REFERENCES warehouse.dim_airport(airport_key),
    destination_airport_key INTEGER REFERENCES warehouse.dim_airport(airport_key)
);

-- ================================================================
-- FACT 1: FLIGHT OPERATIONS
-- Grain: one source flight-operation record
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.fact_flight_operations (
    flight_operation_key  BIGSERIAL PRIMARY KEY,
    source_row_id         BIGINT,
    date_key              INTEGER REFERENCES warehouse.dim_date(date_key),
    airline_key           INTEGER REFERENCES warehouse.dim_airline(airline_key),
    origin_airport_key    INTEGER REFERENCES warehouse.dim_airport(airport_key),
    destination_airport_key INTEGER REFERENCES warehouse.dim_airport(airport_key),
    departure_time        TIME,
    duration_minutes      INTEGER,
    total_stops           INTEGER,
    price_inr             NUMERIC,
    additional_info       VARCHAR(500)
);

-- ================================================================
-- FACT 2: FLIGHT DELAY
-- Grain: one flight-delay record
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.fact_flight_delay (
    delay_fact_key              BIGSERIAL PRIMARY KEY,
    delay_id                    VARCHAR(100),
    date_key                    INTEGER REFERENCES warehouse.dim_date(date_key),
    flight_key                  INTEGER REFERENCES warehouse.dim_flight(flight_key),
    airline_key                 INTEGER REFERENCES warehouse.dim_airline(airline_key),
    departure_delay_min         BIGINT,
    arrival_delay_min           BIGINT,
    delay_reason                VARCHAR(255),
    cancelled                   BOOLEAN,
    diverted                    BOOLEAN,
    weather_delay_min           BIGINT,
    air_traffic_delay_min       BIGINT,
    late_aircraft_delay_min     BIGINT,
    technical_delay_min         BIGINT,
    crew_delay_min              BIGINT,
    security_delay_min          BIGINT,
    airport_operations_delay_min BIGINT,
    distance_km                 BIGINT,
    aircraft_type               VARCHAR(100)
);

-- ================================================================
-- FACT 3: BOOKING
-- Grain: one ticket/booking transaction
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.fact_booking (
    booking_fact_key       BIGSERIAL PRIMARY KEY,
    ticket_id              VARCHAR(100),
    booking_id             VARCHAR(100),
    passenger_key          INTEGER REFERENCES warehouse.dim_passenger(passenger_key),
    flight_key             INTEGER REFERENCES warehouse.dim_flight(flight_key),
    airline_key            INTEGER REFERENCES warehouse.dim_airline(airline_key),
    booking_date_key       INTEGER REFERENCES warehouse.dim_date(date_key),
    travel_date_key        INTEGER REFERENCES warehouse.dim_date(date_key),
    fare_class             VARCHAR(50),
    booking_channel        VARCHAR(100),
    base_fare_inr          NUMERIC,
    tax_inr                NUMERIC,
    total_amount_inr       NUMERIC,
    payment_method         VARCHAR(100),
    payment_status         VARCHAR(50),
    booking_status         VARCHAR(50),
    seat_number            VARCHAR(50),
    baggage_allowance_kg   NUMERIC,
    meal_requested        VARCHAR(20),
    cancellation_date      DATE,
    cancellation_reason    VARCHAR(255),
    refund_amount_inr      NUMERIC,
    refund_status          VARCHAR(50)
);

-- ================================================================
-- FACT 4: BAGGAGE
-- Grain: one airline/month/form-type baggage record
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.fact_baggage (
    baggage_fact_key       BIGSERIAL PRIMARY KEY,
    date_key               INTEGER REFERENCES warehouse.dim_date(date_key),
    airline_key            INTEGER REFERENCES warehouse.dim_airline(airline_key),
    passengers             BIGINT,
    mishandled_baggage     BIGINT,
    enplaned_baggage       BIGINT,
    mishandled_wchr_sctr   BIGINT,
    enplaned_wchr_sctr     BIGINT,
    form_type              VARCHAR(100)
);

-- ================================================================
-- FACT 5: AIRCRAFT MAINTENANCE
-- Grain: one maintenance-task record for an aircraft
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.fact_maintenance (
    maintenance_fact_key   BIGSERIAL PRIMARY KEY,
    aircraft_key           INTEGER REFERENCES warehouse.dim_aircraft(aircraft_key),
    last_execution_date_key INTEGER REFERENCES warehouse.dim_date(date_key),
    item                   VARCHAR(255),
    description            VARCHAR(500),
    block                  VARCHAR(100),
    skill                  VARCHAR(100),
    mxh_est                NUMERIC,
    per_fh                 NUMERIC,
    per_fc                 NUMERIC,
    per_calend             VARCHAR(100),
    task_by_block          VARCHAR(100),
    last_exec_insp         VARCHAR(100),
    last_exec_fh           NUMERIC,
    last_exec_fc           NUMERIC,
    last_exec_dt           DATE,
    limit_insp             VARCHAR(100),
    limit_fh               NUMERIC
);

-- ================================================================
-- FACT 6: CREW SCHEDULING
-- Grain: one crew assignment/duty record
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.fact_crew_scheduling (
    crew_schedule_key       BIGSERIAL PRIMARY KEY,
    crew_key                INTEGER REFERENCES warehouse.dim_crew(crew_key),
    flight_key              INTEGER REFERENCES warehouse.dim_flight(flight_key),
    date_key                INTEGER REFERENCES warehouse.dim_date(date_key),
    duty_start              TIME,
    duty_end                TIME,
    duty_hours              NUMERIC,
    flight_hours            NUMERIC,
    rest_hours_before_duty  NUMERIC,
    experience_years        NUMERIC,
    overtime_hours          NUMERIC,
    leave_days_used         NUMERIC,
    monthly_flight_hours    NUMERIC,
    license_status          VARCHAR(100),
    flight_type             VARCHAR(100),
    duty_status             VARCHAR(100)
);

-- ================================================================
-- FACT 7: AIRCRAFT IOT
-- Grain: one aircraft sensor observation
-- ================================================================
CREATE TABLE IF NOT EXISTS warehouse.fact_aircraft_iot (
    iot_fact_key            BIGSERIAL PRIMARY KEY,
    aircraft_key            INTEGER REFERENCES warehouse.dim_aircraft(aircraft_key),
    date_key                INTEGER REFERENCES warehouse.dim_date(date_key),
    sensor_timestamp        TIMESTAMP,
    sensor_type              VARCHAR(100),
    engine_temperature_c    NUMERIC,
    oil_pressure_psi        NUMERIC,
    vibration_mm_s          NUMERIC,
    fuel_flow_kg_h          NUMERIC,
    altitude_ft             BIGINT,
    speed_kmh               BIGINT,
    latitude                NUMERIC,
    longitude               NUMERIC,
    cabin_temperature_c     NUMERIC,
    humidity_percent        NUMERIC,
    cabin_pressure_kpa      NUMERIC,
    fuel_level_percent      NUMERIC,
    hydraulic_pressure_psi  NUMERIC,
    sensor_status           VARCHAR(100)
);

-- ================================================================
-- INDEXES FOR COMMON ANALYTICS / JOIN PATHS
-- ================================================================
CREATE INDEX IF NOT EXISTS ix_fact_ops_date
ON warehouse.fact_flight_operations(date_key);

CREATE INDEX IF NOT EXISTS ix_fact_ops_airline
ON warehouse.fact_flight_operations(airline_key);

CREATE INDEX IF NOT EXISTS ix_fact_delay_date
ON warehouse.fact_flight_delay(date_key);

CREATE INDEX IF NOT EXISTS ix_fact_delay_flight
ON warehouse.fact_flight_delay(flight_key);

CREATE INDEX IF NOT EXISTS ix_fact_booking_travel_date
ON warehouse.fact_booking(travel_date_key);

CREATE INDEX IF NOT EXISTS ix_fact_booking_passenger
ON warehouse.fact_booking(passenger_key);

CREATE INDEX IF NOT EXISTS ix_fact_baggage_date
ON warehouse.fact_baggage(date_key);

CREATE INDEX IF NOT EXISTS ix_fact_maintenance_aircraft
ON warehouse.fact_maintenance(aircraft_key);

CREATE INDEX IF NOT EXISTS ix_fact_crew_date
ON warehouse.fact_crew_scheduling(date_key);

CREATE INDEX IF NOT EXISTS ix_fact_iot_aircraft_date
ON warehouse.fact_aircraft_iot(aircraft_key, date_key);

-- ================================================================
-- STAR SCHEMA VALIDATION / INVENTORY
-- ================================================================
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'warehouse'
ORDER BY table_name;
