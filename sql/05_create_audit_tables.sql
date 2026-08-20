-- ============================================================
-- EADP - Audit Tables
-- ============================================================


-- ============================================================
-- ETL Execution Log
-- ============================================================

CREATE TABLE IF NOT EXISTS audit.etl_execution_log (
    execution_id BIGSERIAL PRIMARY KEY,

    job_name VARCHAR(255),

    transformation_name VARCHAR(255),

    source_name VARCHAR(255),

    target_table VARCHAR(255),

    start_time TIMESTAMP,

    end_time TIMESTAMP,

    records_read BIGINT DEFAULT 0,

    records_inserted BIGINT DEFAULT 0,

    records_rejected BIGINT DEFAULT 0,

    status VARCHAR(50),

    error_message TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- ETL Error Log
-- ============================================================

CREATE TABLE IF NOT EXISTS audit.etl_error_log (
    error_id BIGSERIAL PRIMARY KEY,

    execution_id BIGINT,

    source_name VARCHAR(255),

    source_row_number BIGINT,

    target_table VARCHAR(255),

    error_type VARCHAR(100),

    error_message TEXT,

    raw_record TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);