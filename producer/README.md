# Stock Quote Producer

This module fetches real-time stock quotes from the Finnhub API and streams them to Apache Kafka.

## Features

- Fetches live stock market data from Finnhub API
- Streams data to Kafka topic in real-time
- Configurable via environment variables
- Robust error handling and logging
- Graceful shutdown on interrupt

## Configuration

Set these environment variables in your `.env` file:

```env
FINNHUB_API_KEY=your_api_key_here
KAFKA_BOOTSTRAP_SERVERS=host.docker.internal:29092
KAFKA_TOPIC=stock-quotes
```

## Stock Symbols

Currently tracking:
- AAPL (Apple)
- MSFT (Microsoft)
- TSLA (Tesla)
- GOOGL (Google)
- AMZN (Amazon)
- NVDA (NVIDIA)
- META (Meta)
- NFLX (Netflix)

To add more symbols, edit the `SYMBOLS` list in `producer.py`.

## Running the Producer

```bash
# Make sure Kafka is running
docker-compose up -d kafka zookeeper

# Run the producer
python producer/producer.py
```

## Data Format

Each message sent to Kafka contains:

```json
{
  "c": 150.25,           // Current price
  "h": 152.00,           // High price of the day
  "l": 149.50,           // Low price of the day
  "o": 150.00,           // Open price
  "pc": 149.75,          // Previous close price
  "t": 1234567890,       // Timestamp
  "symbol": "AAPL",      // Stock symbol
  "fetched_at": 1234567890  // Fetch timestamp
}
```

## Troubleshooting

**API Key Issues:**
- Verify your Finnhub API key is valid
- Check API rate limits (free tier: 60 calls/minute)

**Kafka Connection Issues:**
- Ensure Kafka container is running
- Verify bootstrap servers address
- Check network connectivity

**Rate Limiting:**
- The producer waits 6 seconds between batches
- Adjust sleep time if needed for your API tier
