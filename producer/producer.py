#Import requirements
import os
import time
import json
import requests
import logging
from kafka import KafkaProducer
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

#Define variables for API
API_KEY = os.getenv("FINNHUB_API_KEY", "<<YOUR API KEY>>")
BASE_URL = "https://finnhub.io/api/v1/quote"
KAFKA_SERVERS = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "host.docker.internal:29092").split(",")
KAFKA_TOPIC = os.getenv("KAFKA_TOPIC", "stock-quotes")
SYMBOLS = ["AAPL", "MSFT", "TSLA", "GOOGL", "AMZN", "NVDA", "META", "NFLX"]

#Initial Producer
try:
    producer = KafkaProducer(
        bootstrap_servers=KAFKA_SERVERS,
        value_serializer=lambda v: json.dumps(v).encode("utf-8"),
        acks='all',
        retries=3,
        max_in_flight_requests_per_connection=1
    )
    logger.info(f"Kafka producer initialized successfully. Connected to {KAFKA_SERVERS}")
except Exception as e:
    logger.error(f"Failed to initialize Kafka producer: {e}")
    raise

#Retrieve Data
def fetch_quote(symbol):
    """Fetch stock quote from Finnhub API"""
    url = f"{BASE_URL}?symbol={symbol}&token={API_KEY}"
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()
        
        # Add metadata
        data["symbol"] = symbol
        data["fetched_at"] = int(time.time())
        
        logger.info(f"Successfully fetched quote for {symbol}: ${data.get('c', 'N/A')}")
        return data
    except requests.exceptions.RequestException as e:
        logger.error(f"Error fetching {symbol}: {e}")
        return None
    except Exception as e:
        logger.error(f"Unexpected error for {symbol}: {e}")
        return None

#Looping and Pushing to Stream
def main():
    """Main producer loop"""
    logger.info(f"Starting stock quote producer for symbols: {', '.join(SYMBOLS)}")
    
    try:
        while True:
            for symbol in SYMBOLS:
                quote = fetch_quote(symbol)
                if quote:
                    try:
                        future = producer.send(KAFKA_TOPIC, value=quote)
                        # Wait for send to complete
                        record_metadata = future.get(timeout=10)
                        logger.info(f"Sent {symbol} to topic {record_metadata.topic} partition {record_metadata.partition}")
                    except Exception as e:
                        logger.error(f"Failed to send {symbol} to Kafka: {e}")
                else:
                    logger.warning(f"Skipping {symbol} due to fetch error")
            
            logger.info(f"Completed batch. Sleeping for 6 seconds...")
            time.sleep(6)
    
    except KeyboardInterrupt:
        logger.info("Shutting down producer...")
    finally:
        producer.flush()
        producer.close()
        logger.info("Producer closed successfully")

if __name__ == "__main__":
    main()
