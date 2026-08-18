
# Enterprise Aviation Data Platform (EADP)

## UC8 — Enterprise Aviation Data Platform

### Building a Unified Airline Operations & Passenger Analytics Platform

---

## 1. Project Overview

The **Enterprise Aviation Data Platform (EADP)** is an enterprise data engineering project designed for **ABC Airways Ltd.**

ABC Airways operates over 500 daily domestic and international flights across multiple airports. The airline generates millions of records from multiple independent enterprise systems, including:

- Flight Operations Systems
- Passenger Reservation Systems (PRS)
- Airport Operations
- Baggage Handling Systems
- Aircraft Maintenance Systems
- Crew Management Systems
- Ticketing and Booking Systems
- Customer Relationship Management (CRM)
- Flight Delay Reporting Systems
- Aircraft IoT Monitoring Systems

Since these systems operate independently, the airline faces challenges in monitoring flight performance, reducing delays, improving passenger experience, optimizing aircraft utilization, and generating enterprise-wide operational insights.

The objective of this project is to design and implement an **enterprise-grade aviation data platform** that integrates heterogeneous airline data sources into a unified platform for data engineering, data warehousing, governance, and analytics.

---

# 2. Business Problem

ABC Airways generates large volumes of data from multiple operational and business systems every day.

These systems operate independently and may contain data in different formats and structures. This makes it difficult for the organization to obtain a unified view of airline operations.

The major business challenges include:

- Difficulty monitoring flight performance
- Difficulty identifying flight delays and delay trends
- Limited visibility into passenger booking and travel patterns
- Difficulty monitoring baggage handling performance
- Challenges in optimizing aircraft utilization
- Difficulty integrating aircraft maintenance information
- Limited enterprise-wide operational visibility
- Difficulty generating consistent reports
- Lack of centralized and standardized enterprise data

The proposed Enterprise Aviation Data Platform addresses these challenges by integrating data from multiple source systems and making it available for operational, analytical, and executive reporting.

---

# 3. Project Objectives

The primary objective of EADP is to build an enterprise-grade aviation data platform that:

1. Collects airline operational data from multiple heterogeneous enterprise systems.
2. Cleans, validates, and standardizes passenger, flight, and maintenance data.
3. Stores curated datasets in an enterprise PostgreSQL Data Warehouse.
4. Maintains metadata, audit logs, and end-to-end data lineage.
5. Supports airline operations.
6. Supports passenger analytics.
7. Supports aircraft maintenance planning.
8. Supports executive reporting.
9. Uses Git and GitHub for collaborative version control.
10. Produces enterprise-standard technical documentation.
11. Follows Agile Scrum development practices.

---

# 4. Technology Stack

| Category | Technology |
|---|---|
| ETL | Pentaho Data Integration (Spoon) |
| Database | PostgreSQL |
| Programming | Python / Pandas |
| Version Control | Git / GitHub |
| Reporting | Power BI |
| Documentation | Markdown / MS Word |
| Project Management | Agile Scrum |

---

# 5. Project Scope

## 5.1 In Scope

The project includes:

- Airline data source analysis
- Data source inventory
- Data dictionary
- Heterogeneous data ingestion
- CSV ingestion
- Excel ingestion
- JSON ingestion
- XML ingestion
- SQL data ingestion
- PostgreSQL staging
- Data profiling
- Data cleansing
- Data validation
- Data transformation
- Data warehouse development
- Fact and dimension tables
- Metadata management
- Data lineage
- ETL orchestration
- Data reconciliation
- Business analytics
- Power BI dashboards
- Git/GitHub version control
- Sprint-based Agile development
- Technical documentation

## 5.2 Out of Scope for Initial Sprint

The initial implementation focuses on **Sprint 0 and Sprint 1**.

Advanced data profiling, data warehouse implementation, governance, lineage, and Power BI analytics are planned for subsequent sprints.

---

# 6. High-Level Architecture


                         AIRLINE SOURCE SYSTEMS
                                  |
             +--------------------+--------------------+
             |          |         |         |          |
             v          v         v         v          v
            CSV       Excel      JSON       XML        SQL
             |          |         |         |          |
             +----------+---------+---------+----------+
                                  |
                                  v
                    +-------------------------+
                    |   PENTAHO DATA          |
                    |   INTEGRATION (SPOON)   |
                    +------------+------------+
                                 |
                                 v
                    +-------------------------+
                    |   BRONZE / RAW          |
                    |   LANDING ZONE          |
                    +------------+------------+
                                 |
                                 v
                    +-------------------------+
                    |   POSTGRESQL STAGING    |
                    |   DATABASE               |
                    +------------+------------+
                                 |
                                 v
                    +-------------------------+
                    | DATA PROFILING &        |
                    | DATA QUALITY             |
                    +------------+------------+
                                 |
                                 v
                    +-------------------------+
                    |   SILVER / CURATED      |
                    |   DATA                   |
                    +------------+------------+
                                 |
                                 v
                    +-------------------------+
                    |   GOLD / DATA WAREHOUSE |
                    |   FACT + DIMENSIONS      |
                    +------------+------------+
                                 |
                    +------------+------------+
                    |                         |
                    v                         v
              DATA MARTS                ANALYTICS
                                              |
                                              v
                                      +---------------+
                                      |    POWER BI   |
                                      +---------------+


---

# 7. Data Sources

The project considers the following airline source systems:

| Source ID | Source System                          | Business Area        |
| --------- | -------------------------------------- | -------------------- |
| SRC001    | Flight Operations System               | Flight Operations    |
| SRC002    | Passenger Reservation System (PRS)     | Passenger Management |
| SRC003    | Airport Operations Database            | Airport Operations   |
| SRC004    | Baggage Handling System                | Baggage Operations   |
| SRC005    | Aircraft Maintenance System            | Maintenance          |
| SRC006    | Crew Scheduling System                 | Crew Management      |
| SRC007    | Ticketing & Booking System             | Commercial           |
| SRC008    | Customer Relationship Management (CRM) | Customer Management  |
| SRC009    | Flight Delay Reports                   | Operations           |
| SRC010    | Aircraft IoT Sensor Logs               | Aircraft Monitoring  |

> **Note:** The industry use case identifies these source systems. The exact file names, individual source formats, and refresh frequencies are implementation decisions for the project unless explicitly defined elsewhere.

---

# 8. Source Inventory

The Source Inventory documents where the data originates and how it enters the data platform.

The inventory will contain information such as:

| Field            | Description                              |
| ---------------- | ---------------------------------------- |
| Source ID        | Unique identifier for the source         |
| Source System    | Name of source system                    |
| Business Area    | Business function associated with source |
| Data Entity      | Main entity/data produced                |
| Source Format    | CSV, Excel, JSON, XML, SQL, etc.         |
| Source Location  | File, database, or system location       |
| Frequency        | Expected ingestion frequency             |
| Ingestion Method | Pentaho transformation/method            |
| Target Layer     | Target landing/staging layer             |
| Target Table     | PostgreSQL target table                  |
| Business Owner   | Responsible business area                |
| Status           | Planned/In Progress/Completed            |

The source inventory will be maintained at:

```text
docs/source-inventory.md
```

---

# 9. Data Dictionary

The Data Dictionary defines the fields contained within the source datasets and database tables.

It will contain information such as:

| Field               | Description                             |
| ------------------- | --------------------------------------- |
| Source System       | Origin of the field                     |
| Source Entity       | File/table/entity                       |
| Column Name         | Field name                              |
| Data Type           | VARCHAR, INTEGER, DATE, TIMESTAMP, etc. |
| Length              | Maximum length where applicable         |
| Nullable            | Whether NULL values are allowed         |
| Primary Key         | Whether field acts as a primary key     |
| Business Definition | Meaning of the field                    |
| Example             | Sample value                            |
| Target Table        | PostgreSQL destination                  |
| Target Column       | Destination field                       |
| Transformation Rule | Required transformation                 |

The Data Dictionary will be maintained at:

```text
metadata/data-dictionary.md
```

---

# 10. Data Formats

The Sprint 1 ingestion layer supports heterogeneous data formats:

```text
CSV
Excel
JSON
XML
SQL / Relational Database
```

The data is processed through Pentaho Data Integration before being loaded into PostgreSQL staging tables.

---

# 11. Data Engineering Layers

The platform follows a layered architecture.

```text
SOURCE
   |
   v
BRONZE
   |
   v
STAGING
   |
   v
SILVER
   |
   v
GOLD
   |
   v
ANALYTICS
```

---

## 11.1 Bronze Layer

The Bronze layer represents the raw ingestion or landing zone.

### Purpose

* Receive incoming source data
* Preserve raw information
* Maintain source-level information
* Support ingestion traceability
* Provide a raw landing area before transformation

Directory:

```text
bronze/
├── ingestion/
└── staging/
```

---

# 12. PostgreSQL Staging Layer

PostgreSQL staging tables act as the relational landing area for ingested aviation data.

The staging layer separates raw ingestion from subsequent cleansing, validation, and transformation activities.

Example staging tables:

```text
staging.stg_flights
staging.stg_passengers
staging.stg_airports
staging.stg_baggage
staging.stg_maintenance
staging.stg_crew
staging.stg_tickets
staging.stg_customers
staging.stg_delays
staging.stg_iot_sensor_logs
```

Typical data flow:

```text
Source File / Database
          |
          v
Pentaho Transformation
          |
          v
PostgreSQL Staging Table
          |
          v
Data Quality Processing
```

---

# 13. Silver Layer

The Silver layer contains cleaned, validated, and standardized data.

Typical activities include:

* Removing duplicate records
* Handling missing values
* Standardizing data types
* Standardizing airport codes
* Validating flight information
* Validating passenger information
* Validating baggage information
* Validating maintenance information
* Applying transformation rules

Directory:

```text
silver/
├── cleansing/
├── validation/
└── transformations/
```

---

# 14. Gold Layer

The Gold layer contains business-ready datasets for analytics and reporting.

Directory:

```text
gold/
├── warehouse/
├── datamarts/
└── analytics/
```

The Gold layer is designed to support:

* Flight performance analysis
* Flight delay analysis
* Passenger analytics
* Aircraft utilization
* Maintenance analytics
* Baggage performance
* Airport operational analysis
* Executive reporting

---

# 15. Pentaho ETL Architecture

Pentaho Data Integration (Spoon) is used as the primary ETL tool.

The general ingestion process is:

```text
SOURCE
   |
   v
EXTRACT
   |
   v
VALIDATE
   |
   v
TRANSFORM
   |
   v
LOAD
   |
   v
POSTGRESQL STAGING
```

---

# 16. Pentaho Transformations

The Sprint 1 implementation will include transformations for the required source formats.

```text
pentaho/
└── transformations/
    ├── csv_to_postgres.ktr
    ├── excel_to_postgres.ktr
    ├── json_to_postgres.ktr
    ├── xml_to_postgres.ktr
    └── sql_to_postgres.ktr
```

---

## 16.1 CSV Ingestion

```text
CSV File
   |
   v
CSV File Input
   |
   v
Select Values
   |
   v
Data Type Conversion
   |
   v
Validation
   |
   v
Table Output
   |
   v
PostgreSQL Staging
```

---

## 16.2 Excel Ingestion

```text
Excel File
   |
   v
Microsoft Excel Input
   |
   v
Field Mapping
   |
   v
Data Type Conversion
   |
   v
Validation
   |
   v
PostgreSQL Staging
```

---

## 16.3 JSON Ingestion

```text
JSON File
   |
   v
JSON Input
   |
   v
Field Mapping
   |
   v
Data Type Conversion
   |
   v
Validation
   |
   v
PostgreSQL Staging
```

---

## 16.4 XML Ingestion

```text
XML File
   |
   v
Get Data From XML
   |
   v
Field Mapping
   |
   v
Data Type Conversion
   |
   v
Validation
   |
   v
PostgreSQL Staging
```

---

## 16.5 SQL Ingestion

```text
Source Database
      |
      v
Table Input
      |
      v
Field Mapping
      |
      v
Validation
      |
      v
PostgreSQL Staging
```

---

# 17. Logging and Exception Handling

The ingestion pipelines include logging and exception handling.

Important operational information includes:

* Pipeline start time
* Pipeline end time
* Source name
* Source file/table
* Number of records read
* Number of records processed
* Number of records rejected
* Error count
* Error messages
* Pipeline status

Example:

```text
------------------------------------------------
Pipeline: csv_to_postgres
Source: flights.csv

Start Time: 2026-08-18 10:00:00
End Time:   2026-08-18 10:02:15

Records Read:      10,000
Records Loaded:     9,950
Records Rejected:      50

Status: SUCCESS
------------------------------------------------
```

---

# 18. Dataset Organization

Sample datasets will be organized by business domain.

```text
datasets/
├── flight_operations/
├── passenger_reservation/
├── airport_operations/
├── baggage/
├── maintenance/
├── crew/
├── ticketing/
├── crm/
├── delays/
└── iot/
```

Example:

```text
datasets/
├── flight_operations/
│   └── flights.csv
│
├── passenger_reservation/
│   └── passengers.json
│
├── airport_operations/
│   └── airports.xlsx
│
├── baggage/
│   └── baggage.xml
│
└── maintenance/
    └── maintenance.sql
```

---

# 19. SQL Database Organization

SQL scripts are organized according to their purpose.

```text
sql/
├── staging/
├── warehouse/
└── analytics/
```

### Staging

Contains:

* Schema creation
* Staging table creation
* Staging validation queries

Example:

```text
sql/staging/
├── create_staging_schema.sql
├── create_staging_tables.sql
└── validate_staging_data.sql
```

### Warehouse

Contains:

* Dimension table creation
* Fact table creation
* Star schema implementation

### Analytics

Contains:

* Operational queries
* KPI queries
* Business reporting queries

---

# 20. Python

Python and Pandas will be used primarily for data profiling and data quality analysis.

Directory:

```text
python/
```

Potential activities include:

* Dataset inspection
* Missing-value analysis
* Duplicate detection
* Data-type analysis
* Statistical profiling
* Data quality assessment
* Data validation

Python implementation will be primarily expanded during Sprint 2.

---

# 21. Metadata Management

Metadata provides information about the data used within the platform.

Directory:

```text
metadata/
├── data-dictionary.md
├── business-glossary.md
└── metadata-repository.md
```

Metadata activities include:

* Dataset definitions
* Column definitions
* Business definitions
* Source information
* Target information
* Transformation information
* Ownership information

---

# 22. Data Lineage

Data lineage documents the movement of data from source systems to analytical outputs.

Example:

```text
Flight Operations System
          |
          v
      flights.csv
          |
          v
   Pentaho Transformation
          |
          v
  staging.stg_flights
          |
          v
   Data Cleansing
          |
          v
   Silver Flight Data
          |
          v
   Gold Flight Fact
          |
          v
     Power BI
```

The detailed lineage implementation is planned for Sprint 3.

Directory:

```text
lineage/
```

---

# 23. Business Analytics

The curated datasets are intended to support several business analytics areas.

## Flight Analytics

* Flight punctuality
* Delay trends
* Route performance
* Flight status
* Operational performance

## Passenger Analytics

* Passenger booking patterns
* Passenger travel patterns
* Customer behavior

## Aircraft Analytics

* Aircraft utilization
* Maintenance schedules
* Maintenance history

## Baggage Analytics

* Baggage handling performance
* Baggage operational issues

## Airport Analytics

* Airport operational planning
* Airport performance

## Executive Analytics

* Enterprise operational KPIs
* Financial reporting
* Executive performance reporting

---

# 24. Agile Scrum Methodology

The project follows an Agile Scrum development approach.

Each sprint follows:

```text
Sprint Planning
      |
      v
Task Development
      |
      v
Testing
      |
      v
Documentation
      |
      v
Git Commit
      |
      v
Sprint Review
      |
      v
Sprint Completion
```

---

# 25. Sprint Roadmap

## Sprint 0 — Project Initiation & Architecture

### Objective

Understand the airline business ecosystem and design the enterprise data platform before development begins.

### Tasks

* Study the airline business problem
* Identify business stakeholders
* Prepare Business Requirement Document
* Identify airline data sources
* Define project scope
* Design high-level architecture
* Create Git repository
* Create enterprise repository structure
* Prepare Product Backlog

### Deliverables

* Business Requirements Document
* Solution Architecture
* Git Repository
* Sprint Backlog
* Project Charter

### Git Milestone

```text
Tag: sprint-0
```

---

# 26. Sprint 1 — Data Discovery & Ingestion

### Objective

Build the Aviation Raw Data Landing Zone by integrating data from multiple airline systems.

### Tasks

* Analyze airline source systems
* Prepare Data Dictionary
* Develop CSV ingestion
* Develop Excel ingestion
* Develop JSON ingestion
* Develop XML ingestion
* Develop SQL ingestion
* Load raw aviation data into PostgreSQL staging tables
* Implement logging
* Implement exception handling
* Test ingestion pipelines
* Commit successful ingestion work to Git

### Deliverables

* Source Inventory
* Data Dictionary
* Pentaho ETL Pipelines
* PostgreSQL Staging Database
* Git Commit History

### Git Milestone

```text
Tag: sprint-1
```

---

# 27. Sprint 2 — Data Profiling & Data Warehouse

### Objective

Transform raw airline operational data into trusted datasets for enterprise analytics.

### Planned Tasks

* Profile aviation datasets using Python
* Identify duplicate passenger records
* Identify missing flight information
* Identify baggage inconsistencies
* Identify maintenance data quality issues
* Standardize passenger master data
* Standardize airport master data
* Standardize aircraft master data
* Standardize flight master data
* Design Star Schema
* Create Fact tables
* Create Dimension tables
* Populate warehouse tables
* Develop SQL queries for operational reporting
* Push incremental updates to Git

### Deliverables

* Data Profiling Report
* Data Quality Report
* Star Schema
* PostgreSQL Data Warehouse
* SQL Scripts
* Git Repository Updates

---

# 28. Sprint 3 — Data Governance, Lineage & Analytics

### Objective

Prepare the aviation platform for enterprise deployment through governance, traceability, and analytics.

### Planned Tasks

* Document source-to-target mappings
* Prepare Data Lineage documentation
* Create Aviation Business Glossary
* Implement Pentaho Jobs
* Validate passenger data
* Validate baggage data
* Validate flight data
* Validate maintenance data
* Perform data reconciliation
* Develop executive Power BI dashboards
* Tag final project release in Git
* Prepare project presentation
* Prepare technical documentation

### Deliverables

* Data Lineage Document
* Metadata Repository
* Pentaho Jobs
* Validation Report
* Power BI Dashboard
* Final Git Release
* Project Report
* Sprint Presentation

### Git Milestone

```text
Tag: final-release
```

---

# 29. Git and GitHub Version Control

Git and GitHub are used to maintain the complete project development history.

The project follows logical, meaningful, and incremental commits.

Example commit history:

```text
chore: initialize EADP repository structure

docs: add project README and overview

docs: add project charter

docs: add business requirements document

docs: add stakeholder analysis

docs: add enterprise solution architecture

docs: add Sprint 0 and Sprint 1 backlog

feat: complete Sprint 0 project initiation and architecture

docs: add airline source system inventory

docs: add aviation source data dictionary

data: add sample aviation source datasets

feat: add PostgreSQL staging table definitions

feat: add CSV ingestion transformation

feat: add Excel ingestion transformation

feat: add JSON ingestion transformation

feat: add XML ingestion transformation

feat: add SQL source ingestion transformation

feat: add ingestion logging and exception handling

test: add staging data validation queries

docs: add Sprint 1 ingestion documentation

feat: complete Sprint 1 data discovery and ingestion
```

---

# 30. Git Commit Convention

The project uses conventional commit prefixes.

| Prefix      | Purpose                    |
| ----------- | -------------------------- |
| `feat:`     | New functionality          |
| `fix:`      | Bug fix                    |
| `docs:`     | Documentation              |
| `data:`     | Dataset changes            |
| `test:`     | Testing                    |
| `config:`   | Configuration              |
| `refactor:` | Code restructuring         |
| `chore:`    | Repository/tooling changes |

Examples:

```bash
git add docs/BRD.md
git commit -m "docs: add business requirements document"
```

```bash
git add datasets/
git commit -m "data: add sample aviation source datasets"
```

```bash
git add pentaho/transformations/csv_to_postgres.ktr
git commit -m "feat: add CSV ingestion transformation"
```

```bash
git add sql/staging/validate_staging_data.sql
git commit -m "test: add staging data validation queries"
```

---

# 31. Git Workflow

The recommended development workflow is:

```text
Create / Modify
      |
      v
Test
      |
      v
git status
      |
      v
git diff
      |
      v
git add
      |
      v
git commit
      |
      v
git push
```

Commands:

```bash
git status
git diff
git add <file-or-directory>
git commit -m "type: meaningful message"
git push
```

---

# 32. Sprint Tags

Git tags identify completed sprint milestones.

After Sprint 0:

```bash
git tag -a sprint-0 -m "Sprint 0 completed"
git push origin sprint-0
```

After Sprint 1:

```bash
git tag -a sprint-1 -m "Sprint 1 completed"
git push origin sprint-1
```

At the end of the project:

```bash
git tag -a final-release -m "Final project release"
git push origin final-release
```

---

# 33. Git Security

Sensitive information must not be committed to GitHub.

The following should not be committed:

```text
.env
Database passwords
API keys
Access tokens
Private credentials
Secret configuration
```

Example `.gitignore`:

```gitignore
# Environment files
.env

# Logs
*.log

# macOS
.DS_Store

# IDE
.idea/
.vscode/

# Python
__pycache__/
*.pyc

# Temporary files
*.tmp
```

Use an `.env.example` file for documenting required environment variables.

Example:

```text
DB_HOST=
DB_PORT=5432
DB_NAME=
DB_USER=
DB_PASSWORD=
```

---

# 34. Repository Structure

```text
ProjectTitle/
│
├── docs/
│   ├── BRD.md
│   ├── project-charter.md
│   ├── stakeholder-analysis.md
│   ├── solution-architecture.md
│   ├── source-inventory.md
│   ├── sprint-backlog.md
│   ├── sprint-0-summary.md
│   └── sprint-1-summary.md
│
├── config/
│   ├── .env.example
│   └── ingestion-config.json
│
├── datasets/
│   ├── flight_operations/
│   ├── passenger_reservation/
│   ├── airport_operations/
│   ├── baggage/
│   ├── maintenance/
│   ├── crew/
│   ├── ticketing/
│   ├── crm/
│   ├── delays/
│   └── iot/
│
├── bronze/
│   ├── ingestion/
│   └── staging/
│
├── silver/
│   ├── cleansing/
│   ├── validation/
│   └── transformations/
│
├── gold/
│   ├── warehouse/
│   ├── datamarts/
│   └── analytics/
│
├── pentaho/
│   ├── transformations/
│   └── jobs/
│
├── python/
│
├── sql/
│   ├── staging/
│   ├── warehouse/
│   └── analytics/
│
├── metadata/
│   ├── data-dictionary.md
│   ├── business-glossary.md
│   └── metadata-repository.md
│
├── lineage/
│
├── dashboards/
│
├── deployment/
│
├── tests/
│   ├── ingestion/
│   ├── data-quality/
│   └── integration/
│
├── .gitignore
└── README.md
```

---

# 35. Testing Strategy

Testing will be performed at multiple stages.

## 35.1 Ingestion Testing

Verify:

* Source file can be read
* Correct number of records are read
* Correct number of records are loaded
* Columns are mapped correctly
* Data types are correct
* Invalid records are handled
* Errors are logged

## 35.2 Database Testing

Verify:

* PostgreSQL schema exists
* Staging tables exist
* Columns exist
* Data types are correct
* Records are loaded successfully
* Record counts are correct

## 35.3 Data Quality Testing

Verify:

* Missing values
* Duplicate records
* Invalid airport codes
* Invalid dates
* Invalid numerical values
* Invalid flight information
* Referential consistency

---

# 36. Example Data Validation

Example SQL validation:

```sql
SELECT COUNT(*)
FROM staging.stg_flights;
```

Check missing flight IDs:

```sql
SELECT COUNT(*)
FROM staging.stg_flights
WHERE flight_id IS NULL;
```

Check duplicate flights:

```sql
SELECT flight_id, COUNT(*)
FROM staging.stg_flights
GROUP BY flight_id
HAVING COUNT(*) > 1;
```

Check negative delays:

```sql
SELECT *
FROM staging.stg_flights
WHERE delay_minutes < 0;
```

---

# 37. Environment Setup

## Prerequisites

Install the following software:

* Git
* GitHub account
* PostgreSQL
* Pentaho Data Integration (Spoon)
* Python
* Pandas
* Power BI

---

# 38. Clone the Repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
```

Move into the project:

```bash
cd <PROJECT_DIRECTORY>
```

---

# 39. Configure PostgreSQL

Create the project database.

Example:

```sql
CREATE DATABASE aviation_data_platform;
```

Create the staging schema:

```sql
CREATE SCHEMA staging;
```

Create staging tables using the SQL scripts under:

```text
sql/staging/
```

---

# 40. Configure Environment Variables

Copy the example environment file:

```bash
cp .env.example .env
```

Update the values locally.

Example:

```text
DB_HOST=localhost
DB_PORT=5432
DB_NAME=aviation_data_platform
DB_USER=<your_user>
DB_PASSWORD=<your_password>
```

Do not commit the `.env` file.

---

# 41. Run Pentaho

Open Pentaho Data Integration (Spoon).

Open the required `.ktr` transformation.

Example:

```text
pentaho/transformations/csv_to_postgres.ktr
```

Execute the transformation and verify the PostgreSQL staging table.

---

# 42. Validate the Data

After ingestion, execute the validation SQL scripts.

Example:

```text
sql/staging/validate_staging_data.sql
```

Verify:

* Row counts
* Null values
* Data types
* Duplicate records
* Invalid values
* Error records

---

# 43. Project Status

## Sprint 0

**Status:** In Progress

* [ ] Business Requirements Document
* [ ] Project Charter
* [ ] Stakeholder Analysis
* [ ] Solution Architecture
* [ ] Git Repository
* [ ] Enterprise Repository Structure
* [ ] Product Backlog
* [ ] Sprint Backlog

## Sprint 1

**Status:** Not Started / In Progress

* [ ] Source Inventory
* [ ] Data Dictionary
* [ ] Sample Datasets
* [ ] CSV Ingestion
* [ ] Excel Ingestion
* [ ] JSON Ingestion
* [ ] XML Ingestion
* [ ] SQL Ingestion
* [ ] PostgreSQL Staging Tables
* [ ] Logging
* [ ] Exception Handling
* [ ] Data Validation
* [ ] Sprint 1 Documentation
* [ ] Git Commit History
* [ ] Sprint 1 Git Tag

## Sprint 2

**Status:** Not Started

* [ ] Python Data Profiling
* [ ] Data Quality Analysis
* [ ] Master Data Standardization
* [ ] Star Schema
* [ ] Fact Tables
* [ ] Dimension Tables
* [ ] PostgreSQL Data Warehouse
* [ ] SQL Reporting Queries

## Sprint 3

**Status:** Not Started

* [ ] Source-to-Target Mapping
* [ ] Data Lineage
* [ ] Business Glossary
* [ ] Pentaho Jobs
* [ ] Data Reconciliation
* [ ] Validation Report
* [ ] Power BI Dashboard
* [ ] Final Git Release
* [ ] Project Report
* [ ] Project Presentation

---

# 44. Expected Final Data Flow

```text
+------------------------------------------------+
|              AIRLINE SOURCE SYSTEMS            |
+------------------------------------------------+
                       |
                       v
+------------------------------------------------+
|              SOURCE INVENTORY                  |
|              DATA DICTIONARY                  |
+------------------------------------------------+
                       |
                       v
+------------------------------------------------+
|             PENTAHO DATA INTEGRATION           |
|                                                 |
| CSV | Excel | JSON | XML | SQL                 |
+------------------------------------------------+
                       |
                       v
+------------------------------------------------+
|              BRONZE / LANDING                  |
+------------------------------------------------+
                       |
                       v
+------------------------------------------------+
|            POSTGRESQL STAGING                  |
+------------------------------------------------+
                       |
                       v
+------------------------------------------------+
|        PYTHON DATA PROFILING & QUALITY         |
+------------------------------------------------+
                       |
                       v
+------------------------------------------------+
|                 SILVER LAYER                   |
|       Cleaned / Validated / Standardized       |
+------------------------------------------------+
                       |
                       v
+------------------------------------------------+
|                  GOLD LAYER                    |
|        Warehouse / Data Marts / Analytics      |
+------------------------------------------------+
                       |
                       v
+------------------------------------------------+
|                   POWER BI                     |
|          Operational & Executive Reports       |
+------------------------------------------------+
```

---

# 45. Business Analytics Enablement

The final curated datasets should enable analytics teams to:

* Analyze flight punctuality
* Analyze flight delay trends
* Monitor aircraft utilization
* Monitor maintenance schedules
* Evaluate passenger booking patterns
* Analyze passenger travel patterns
* Analyze baggage handling performance
* Support airport operational planning
* Generate executive operational reports
* Generate financial and business reports

---

# 46. Project Deliverables

The complete project is expected to produce:

## Documentation

```text
BRD
Project Charter
Solution Architecture
Stakeholder Analysis
Source Inventory
Data Dictionary
Data Profiling Report
Data Quality Report
Data Lineage Document
Business Glossary
Project Report
```

## ETL

```text
Pentaho Transformations
Pentaho Jobs
Logging
Exception Handling
```

## Database

```text
PostgreSQL Staging
PostgreSQL Data Warehouse
Fact Tables
Dimension Tables
Data Marts
SQL Scripts
```

## Analytics

```text
Power BI Dashboards
Operational Analytics
Passenger Analytics
Aircraft Analytics
Baggage Analytics
Executive Analytics
```

## Version Control

```text
Git Repository
GitHub Repository
Meaningful Commit History
Sprint Tags
Final Release Tag
```

---

# 47. Learning Outcomes

By completing this project, the following capabilities will be demonstrated:

* Analyze enterprise aviation data requirements
* Integrate heterogeneous airline datasets
* Build end-to-end ETL pipelines using Pentaho
* Perform data profiling using Python/Pandas
* Implement PostgreSQL data warehousing
* Design dimensional models
* Manage data quality
* Maintain metadata
* Maintain data lineage
* Implement data governance
* Use Git and GitHub for collaborative development
* Apply Agile Scrum practices
* Enable business analytics using curated datasets

---

# 48. Team

| Name          | Role                        |
| ------------- | --------------------------- |
| Team Member 1 | Data Engineering            |
| Team Member 2 | ETL / Pentaho               |
| Team Member 3 | PostgreSQL / Data Warehouse |
| Team Member 4 | Analytics / Documentation   |

> Replace the placeholder names and roles with the actual project team information.

---

# 49. GitHub Repository

GitHub Repository:

```text
<ADD-YOUR-GITHUB-REPOSITORY-URL>
```

---

# 50. Project Information

| Item            | Details                           |
| --------------- | --------------------------------- |
| Project         | Enterprise Aviation Data Platform |
| Use Case        | UC8                               |
| Organization    | ABC Airways Ltd.                  |
| Domain          | Aviation                          |
| Methodology     | Agile Scrum                       |
| ETL             | Pentaho Data Integration          |
| Database        | PostgreSQL                        |
| Programming     | Python / Pandas                   |
| Version Control | Git / GitHub                      |
| Reporting       | Power BI                          |
| Current Focus   | Sprint 0 + Sprint 1               |

---

# 51. Sprint 0 and Sprint 1 Focus

The current implementation focuses on:

```text
SPRINT 0
    |
    +-- Business Understanding
    +-- Stakeholder Identification
    +-- BRD
    +-- Scope
    +-- Architecture
    +-- Git Repository
    +-- Repository Structure
    +-- Product Backlog
    |
    v
SPRINT 1
    |
    +-- Source Inventory
    +-- Data Dictionary
    +-- Source Dataset Preparation
    +-- CSV Ingestion
    +-- Excel Ingestion
    +-- JSON Ingestion
    +-- XML Ingestion
    +-- SQL Ingestion
    +-- PostgreSQL Staging
    +-- Logging
    +-- Exception Handling
    +-- Validation
    +-- Git Commit History
```

---

# 52. Sprint Milestones

```text
Sprint 0
    |
    v
Tag: sprint-0
    |
    v
Sprint 1
    |
    v
Tag: sprint-1
    |
    v
Sprint 2
    |
    v
Sprint 3
    |
    v
Tag: final-release
```

---

# 53. Final Project Vision

The final Enterprise Aviation Data Platform will provide a unified data foundation for ABC Airways by integrating data from multiple operational and business systems.

The platform will transform heterogeneous raw data into trusted, curated, and business-ready datasets that support:

```text
                   ENTERPRISE AVIATION DATA PLATFORM
                                  |
       +--------------------------+--------------------------+
       |                          |                          |
       v                          v                          v
 Flight Operations          Passenger Analytics       Maintenance
       |                          |                          |
       +--------------------------+--------------------------+
                                  |
                                  v
                         Enterprise Data Warehouse
                                  |
                                  v
                              Data Marts
                                  |
                                  v
                            Power BI Analytics
                                  |
                                  v
                       Executive Decision Making
```

The project combines **data ingestion, ETL, PostgreSQL, Python/Pandas, data quality, data warehousing, metadata, lineage, Git/GitHub, and business analytics** into an enterprise aviation data engineering solution.

---

## Assignment Reference

This project is based on **UC8: Enterprise Aviation Data Platform (EADP): Building a Unified Airline Operations & Passenger Analytics Platform**.

The use case defines the overall objective, technology stack, Sprint 0 activities and deliverables, and Sprint 1 data discovery and ingestion requirements. Sprint 1 specifically requires source-system analysis, a Data Dictionary, Pentaho ingestion for CSV/Excel/JSON/XML/SQL data, PostgreSQL staging, logging, exception handling, and Git commit history.
