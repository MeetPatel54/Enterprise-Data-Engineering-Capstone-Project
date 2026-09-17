-- ============================================================
-- EADP - Metadata Tables
-- ============================================================

CREATE TABLE IF NOT EXISTS metadata.etl_source_registry (
    source_id VARCHAR(50) PRIMARY KEY,
    source_name VARCHAR(255) NOT NULL,
    source_type VARCHAR(50) NOT NULL,
    source_path VARCHAR(1000),
    target_table VARCHAR(255) NOT NULL,
    active_flag BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- Register the 10 EADP source systems
-- ============================================================

INSERT INTO metadata.etl_source_registry
(
    source_id,
    source_name,
    source_type,
    target_table
)
VALUES
(
    'SRC-001',
    'Flight Operations System',
    'CSV',
    'staging.stg_flight_operations'
),
(
    'SRC-002',
    'Passenger Reservation System',
    'CSV',
    'staging.stg_passenger_reservation'
),
(
    'SRC-003',
    'Airport Operations System',
    'CSV',
    'staging.stg_airport_operations'
),
(
    'SRC-004',
    'Baggage Handling System',
    'CSV',
    'staging.stg_baggage_handling'
),
(
    'SRC-005',
    'Aircraft Maintenance System',
    'EXCEL',
    'staging.stg_aircraft_maintenance'
),
(
    'SRC-006',
    'Crew Scheduling System',
    'EXCEL',
    'staging.stg_crew_scheduling'
),
(
    'SRC-007',
    'Ticketing & Booking System',
    'EXCEL',
    'staging.stg_ticketing_booking'
),
(
    'SRC-008',
    'CRM System',
    'EXCEL',
    'staging.stg_crm'
),
(
    'SRC-009',
    'Flight Delay Reports',
    'JSON',
    'staging.stg_flight_delay'
),
(
    'SRC-010',
    'Aircraft IoT Sensor Logs',
    'JSON',
    'staging.stg_aircraft_iot'
)
ON CONFLICT (source_id)
DO NOTHING;