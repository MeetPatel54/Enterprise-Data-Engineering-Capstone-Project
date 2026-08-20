-- ============================================================
-- EADP - PostgreSQL Staging Tables
-- ============================================================
-- Purpose:
-- Store raw data ingested from CSV, Excel and JSON sources
-- through Pentaho Data Integration.
-- ============================================================

-- ============================================================
-- 1. FLIGHT OPERATIONS
-- Source: CSV
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.stg_flight_operations (
    source_row_id BIGINT,
    airline VARCHAR(255),
    date_of_journey VARCHAR(50),
    source VARCHAR(100),
    destination VARCHAR(100),
    dep_time VARCHAR(20),
    duration VARCHAR(50),
    total_stops VARCHAR(50),
    additional_info VARCHAR(500),
    price NUMERIC(18,2)
);


-- ============================================================
-- 2. PASSENGER RESERVATION
-- Source: CSV
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.stg_passenger_reservation (
    airline VARCHAR(255),
    date_of_journey VARCHAR(50),
    source VARCHAR(100),
    destination VARCHAR(100),
    route VARCHAR(500),
    dep_time VARCHAR(20),
    arrival_time VARCHAR(20),
    duration VARCHAR(50),
    total_stops VARCHAR(50),
    additional_info VARCHAR(500),
    price NUMERIC(18,2)
);


-- ============================================================
-- 3. AIRPORT OPERATIONS
-- Source: CSV
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.stg_airport_operations (
    objectid BIGINT,
    eff_date DATE,
    site_no VARCHAR(50),
    site_type_code VARCHAR(50),
    state_code VARCHAR(50),
    arpt_id VARCHAR(50),
    city VARCHAR(255),
    country_code VARCHAR(20),
    region_code VARCHAR(50),
    ado_code VARCHAR(50),
    state_name VARCHAR(255),
    county_name VARCHAR(255),
    county_assoc_state VARCHAR(255),
    arpt_name VARCHAR(255),
    ownership_type_code VARCHAR(50),
    facility_use_code VARCHAR(50),

    lat_deg NUMERIC(10,4),
    lat_min NUMERIC(10,4),
    lat_sec NUMERIC(10,4),
    lat_hemis VARCHAR(255),
    lat_decimal NUMERIC(12,8),

    long_deg NUMERIC(10,4),
    long_min NUMERIC(10,4),
    long_sec NUMERIC(10,4),
    long_hemis VARCHAR(255),
    long_decimal NUMERIC(12,8),

    survey_method_code VARCHAR(50),

    elev NUMERIC(18,4),
    elev_method_code VARCHAR(50),

    mag_varn NUMERIC(18,4),
    mag_hemis VARCHAR(255),
    mag_varn_year BIGINT,

    tpa NUMERIC(18,4),
    chart_name VARCHAR(255),

    dist_city_to_airport NUMERIC(18,4),
    direction_code VARCHAR(50),

    acreage NUMERIC(18,4),

    resp_artcc_id VARCHAR(50),
    computer_id VARCHAR(50),
    artcc_name VARCHAR(255),

    fss_on_arpt_flag VARCHAR(255),
    fss_id VARCHAR(50),
    fss_name VARCHAR(255),

    phone_no VARCHAR(50),
    toll_free_no VARCHAR(50),

    alt_fss_id VARCHAR(50),
    alt_fss_name VARCHAR(255),
    alt_toll_free_no VARCHAR(50),

    notam_id VARCHAR(50),
    notam_flag VARCHAR(255),

    activation_date VARCHAR(20),

    arpt_status VARCHAR(50),

    far_139_type_code VARCHAR(50),
    far_139_carrier_ser_code VARCHAR(50),

    arff_cert_type_date VARCHAR(20),

    nasp_code VARCHAR(50),
    asp_anlys_dtrm_code VARCHAR(50),

    cust_flag VARCHAR(255),
    lndg_rights_flag VARCHAR(255),
    joint_use_flag VARCHAR(255),
    mil_lndg_flag VARCHAR(255),

    inspect_method_code VARCHAR(50),
    inspector_code VARCHAR(50),

    last_inspection DATE,
    last_info_response DATE,

    fuel_types VARCHAR(500),

    airframe_repair_ser_code VARCHAR(100),
    pwr_plant_repair_ser VARCHAR(100),

    bottled_oxy_type VARCHAR(100),
    bulk_oxy_type VARCHAR(100),

    lgt_sked VARCHAR(100),
    bcn_lgt_sked VARCHAR(100),

    twr_type_code VARCHAR(50),

    seg_circle_mkr_flag VARCHAR(255),
    bcn_lens_color VARCHAR(50),

    lndg_fee_flag VARCHAR(255),
    medical_use_flag VARCHAR(255),

    arpt_psn_source VARCHAR(100),
    position_src_date DATE,

    arpt_elev_source VARCHAR(100),
    elevation_src_date DATE,

    contr_fuel_avbl VARCHAR(100),

    trns_strg_buoy_flag VARCHAR(255),
    trns_strg_hgr_flag VARCHAR(255),
    trns_strg_tie_flag VARCHAR(255),

    other_services VARCHAR(1000),

    wind_indcr_flag VARCHAR(255),

    icao_id VARCHAR(20),
    min_op_network VARCHAR(100),
    user_fee_flag VARCHAR(255),

    cta VARCHAR(100),

    x NUMERIC(18,8),
    y NUMERIC(18,8)
);


-- ============================================================
-- 4. BAGGAGE HANDLING
-- Source: CSV
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.stg_baggage_handling (
    year BIGINT,
    month BIGINT,
    quarter BIGINT,
    airline_id VARCHAR(50),
    carrier VARCHAR(50),
    carrier_name VARCHAR(255),
    unique_carrier VARCHAR(50),
    unique_carrier_name VARCHAR(255),
    passengers BIGINT,
    mishandled_baggage BIGINT,
    enplaned_baggage BIGINT,
    mishandled_wchr_sctr BIGINT,
    enplaned_wchr_sctr BIGINT,
    form_type VARCHAR(100)
);


-- ============================================================
-- 5. AIRCRAFT MAINTENANCE
-- Source: Excel
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.stg_aircraft_maintenance (
    aircraft_id VARCHAR(100),
    item VARCHAR(100),
    description VARCHAR(1000),
    block VARCHAR(100),
    skill VARCHAR(100),

    mxh_est NUMERIC(18,4),
    per_fh NUMERIC(18,4),
    per_fc NUMERIC(18,4),

    per_calend VARCHAR(100),
    task_by_block VARCHAR(100),

    last_exec_insp VARCHAR(100),
    last_exec_fh NUMERIC(18,4),
    last_exec_fc NUMERIC(18,4),
    last_exec_dt DATE,

    limit_insp VARCHAR(100),
    limit_fh NUMERIC(18,4),
    limit_fc NUMERIC(18,4),
    limit_exec_dt DATE
);


-- ============================================================
-- 6. CREW SCHEDULING
-- Source: Excel
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.stg_crew_scheduling (
    assignment_id VARCHAR(100),
    crew_id VARCHAR(100),
    crew_name VARCHAR(255),
    role VARCHAR(100),
    airline VARCHAR(255),
    base_airport VARCHAR(50),

    flight_id VARCHAR(100),
    flight_number VARCHAR(50),

    duty_date DATE,
    duty_start VARCHAR(20),
    duty_end VARCHAR(20),

    duty_hours NUMERIC(18,4),
    flight_hours NUMERIC(18,4),
    rest_hours_before_duty NUMERIC(18,4),

    experience_years NUMERIC(18,4),

    license_status VARCHAR(100),
    flight_type VARCHAR(100),
    duty_status VARCHAR(100),

    overtime_hours NUMERIC(18,4),
    leave_days_used NUMERIC(18,4),
    monthly_flight_hours NUMERIC(18,4)
);


-- ============================================================
-- 7. TICKETING & BOOKING
-- Source: Excel
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.stg_ticketing_booking (
    ticket_id VARCHAR(100),
    booking_id VARCHAR(100),
    passenger_id VARCHAR(100),
    flight_id VARCHAR(100),

    airline VARCHAR(255),
    flight_number VARCHAR(50),

    origin VARCHAR(50),
    destination VARCHAR(50),

    booking_date VARCHAR(50),
    travel_date VARCHAR(50),

    fare_class VARCHAR(50),
    booking_channel VARCHAR(100),

    base_fare_inr NUMERIC(18,2),
    tax_inr NUMERIC(18,2),
    total_amount_inr NUMERIC(18,2),

    payment_method VARCHAR(100),
    payment_status VARCHAR(100),
    booking_status VARCHAR(100),

    seat_number VARCHAR(20),

    baggage_allowance_kg NUMERIC(18,2),

    meal_requested VARCHAR(20),

    cancellation_date VARCHAR(50),
    cancellation_reason VARCHAR(500),

    refund_amount_inr NUMERIC(18,2),
    refund_status VARCHAR(100)
);


-- ============================================================
-- 8. CRM
-- Source: Excel
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.stg_crm (
    customer_id VARCHAR(100),
    name VARCHAR(255),
    age BIGINT,
    gender VARCHAR(50),
    city VARCHAR(255),
    country VARCHAR(100),

    email VARCHAR(255),
    phone VARCHAR(50),

    loyalty_level VARCHAR(100),
    customer_since DATE,

    preferred_channel VARCHAR(100),

    total_flights BIGINT,
    total_spend_inr NUMERIC(18,2),

    last_flight_date DATE,

    feedback_rating NUMERIC(18,4),

    issue_category VARCHAR(255),
    issue_type VARCHAR(255),

    support_channel VARCHAR(100),
    support_ticket_status VARCHAR(100),

    resolution_time_hours NUMERIC(18,4),

    loyalty_points BIGINT,

    marketing_opt_in VARCHAR(20)
);


-- ============================================================
-- 9. FLIGHT DELAY
-- Source: JSON
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.stg_flight_delay (
    delay_id VARCHAR(100),
    flight_id VARCHAR(100),

    date VARCHAR(50),

    airline VARCHAR(255),
    flight_number VARCHAR(50),

    origin VARCHAR(50),
    destination VARCHAR(50),

    scheduled_departure VARCHAR(50),

    departure_delay_min BIGINT,
    arrival_delay_min BIGINT,

    delay_reason VARCHAR(255),

    cancelled VARCHAR(20),
    diverted VARCHAR(20),

    weather_delay_min BIGINT,
    air_traffic_delay_min BIGINT,
    late_aircraft_delay_min BIGINT,
    technical_delay_min BIGINT,
    crew_delay_min BIGINT,
    security_delay_min BIGINT,
    airport_operations_delay_min BIGINT,

    distance_km BIGINT,

    aircraft_type VARCHAR(100)
);


-- ============================================================
-- 10. AIRCRAFT IoT
-- Source: JSON
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.stg_aircraft_iot (
    log_id VARCHAR(100),
    aircraft_id VARCHAR(100),
    aircraft_type VARCHAR(100),
    airline VARCHAR(255),

    timestamp VARCHAR(100),

    sensor_type VARCHAR(100),

    engine_temperature_c NUMERIC(18,4),
    oil_pressure_psi NUMERIC(18,4),
    vibration_mm_s NUMERIC(18,4),
    fuel_flow_kg_h NUMERIC(18,4),

    altitude_ft BIGINT,
    speed_kmh BIGINT,

    latitude NUMERIC(12,8),
    longitude NUMERIC(12,8),

    cabin_temperature_c NUMERIC(18,4),
    humidity_percent NUMERIC(18,4),
    cabin_pressure_kpa NUMERIC(18,4),

    fuel_level_percent NUMERIC(18,4),

    hydraulic_pressure_psi NUMERIC(18,4),

    sensor_status VARCHAR(50)
);