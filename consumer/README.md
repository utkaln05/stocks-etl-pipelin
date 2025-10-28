# Stock Quote Consumer

This module consumes stock quotes from Kafka and stores them in MinIO (S3-compatible storage).

## Features

- Consumes messages from Kafka topic
- Stores data in MinIO buckets
- Organizes files by stock symbol
- Configurable via environment variables
- Robust error handling and logging
- Graceful shutdown on interrupt

## Configuration

Set these environment variables in your `.env` file:

```env
MINIO_ENDPOINT=http://localhost:9002
MINIO_ACCESS_KEY=admin
MINIO_SECRET_KEY=password123
MINIO_BUCKET=bronze-transactions
KAFKA_BOOTSTRAP_SERVERS=host.docker.internal:29092
KAFKA_TOPIC=stock-quotes
```

## Running the Consumer

```bash
# Make sure Kafka and MinIO are running
docker-compose up -d kafka zookeeper minio

# Run the consumer
python consumer/consumer.py
```

## Storage Structure

Files are organized in MinIO as:

```
bronze-transactions/
├── AAPL/
│   ├── 1234567890.json
│   ├── 1234567896.json
│   └── ...
├── MSFT/
│   ├── 1234567890.json
│   └── ...
└── ...
```

Each file contains a single stock quote in JSON format.

## Accessing MinIO

1. Open MinIO Console: http://localhost:9001
2. Login with credentials (admin/password123)
3. Browse the `bronze-transactions` bucket
4. View stored JSON files

## Troubleshooting

**MinIO Connection Issues:**
- Verify MinIO container is running
- Check endpoint URL and port
- Verify credentials

**Kafka Connection Issues:**
- Ensure Kafka is running and accessible
- Check consumer group settings
- Verify topic exists

**Bucket Creation Issues:**
- Check MinIO permissions
- Verify bucket naming conventions
- Review MinIO logs
