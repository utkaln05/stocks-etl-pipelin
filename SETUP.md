# Setup Guide for Real-Time Stocks Market Data Pipeline

## Prerequisites
- Docker and Docker Compose installed
- Python 3.8+ installed
- Finnhub API key (get free at https://finnhub.io/)
- Snowflake account (free trial available)

## Quick Start

### 1. Clone and Setup Environment

```bash
# Navigate to project directory
cd real-time-stocks-mds-main

# Copy environment template
cp .env.example .env

# Edit .env file with your credentials
# Add your Finnhub API key, Snowflake credentials, etc.
```

### 2. Install Python Dependencies

```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On Linux/Mac:
source venv/bin/activate

# Install requirements
pip install -r requirements.txt
```

### 3. Start Docker Services

```bash
# Start all services (Kafka, Zookeeper, MinIO, Airflow, Postgres)
docker-compose up -d

# Check if all services are running
docker-compose ps
```

### 4. Access Web Interfaces

- **Kafdrop (Kafka UI)**: http://localhost:9000
- **MinIO Console**: http://localhost:9001 (admin/password123)
- **Airflow**: http://localhost:8080 (admin/admin)

### 5. Run Producer and Consumer

```bash
# In terminal 1 - Start the producer
python producer/producer.py

# In terminal 2 - Start the consumer
python consumer/consumer.py
```

### 6. Configure Snowflake

1. Create database and schema:
```sql
CREATE DATABASE STOCKS_MDS;
CREATE SCHEMA STOCKS_MDS.COMMON;
USE SCHEMA STOCKS_MDS.COMMON;

CREATE TABLE bronze_stock_quotes_raw (
    raw_data VARIANT,
    loaded_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
```

2. Update your `.env` file with Snowflake credentials

### 7. Setup DBT

```bash
cd dbt_stocks
dbt deps
dbt run
```

## Troubleshooting

### Kafka Connection Issues
- Ensure Docker containers are running: `docker-compose ps`
- Check Kafka logs: `docker logs kafka`

### MinIO Connection Issues
- Verify MinIO is accessible at http://localhost:9002
- Check credentials in `.env` file

### Snowflake Connection Issues
- Verify account identifier format: `<account>.<region>`
- Ensure user has proper permissions

## Architecture Overview

```
Finnhub API → Producer → Kafka → Consumer → MinIO → Airflow → Snowflake → DBT → Power BI
```

## Project Structure

```
.
├── producer/           # Kafka producer (fetches from Finnhub)
├── consumer/           # Kafka consumer (saves to MinIO)
├── dag/               # Airflow DAGs
├── dbt_stocks/        # DBT transformations
├── docker-compose.yml # Docker services configuration
├── requirements.txt   # Python dependencies
├── .env.example       # Environment variables template
└── README.md          # Project documentation
```

## Next Steps

1. Monitor data flow in Kafdrop
2. Check MinIO for stored JSON files
3. Verify Airflow DAG execution
4. Query Snowflake tables
5. Connect Power BI to Snowflake

## Support

For issues or questions, please open an issue on GitHub.
