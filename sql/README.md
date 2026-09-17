# EADP SQL Infrastructure

This directory contains the PostgreSQL SQL scripts used by the
Enterprise Aviation Data Platform (EADP).

## Database

Database name:

`eadp_db`

## Schemas

The EADP PostgreSQL database contains the following schemas:

- `staging` - Raw data ingested through Pentaho
- `metadata` - Source and ETL metadata
- `audit` - ETL execution and error logging
- `warehouse` - Future dimensional data warehouse

## SQL Files

```text
sql/
├── 01_database_setup.sql
├── 02_create_schemas.sql
├── 03_create_staging_tables.sql
├── 04_create_metadata_tables.sql
├── 05_create_audit_tables.sql
└── README.md