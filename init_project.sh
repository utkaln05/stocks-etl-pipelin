#!/bin/bash

# Real-Time Stocks Pipeline - Project Initialization Script

echo "========================================="
echo "Real-Time Stocks Pipeline Setup"
echo "========================================="
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "Creating .env file from template..."
    cp .env.example .env
    echo "✓ .env file created. Please edit it with your credentials."
else
    echo "✓ .env file already exists"
fi

# Create virtual environment
if [ ! -d "venv" ]; then
    echo ""
    echo "Creating Python virtual environment..."
    python -m venv venv
    echo "✓ Virtual environment created"
else
    echo "✓ Virtual environment already exists"
fi

# Activate virtual environment and install dependencies
echo ""
echo "Installing Python dependencies..."
source venv/bin/activate
pip install -r requirements.txt
echo "✓ Dependencies installed"

# Create necessary directories
echo ""
echo "Creating necessary directories..."
mkdir -p logs
mkdir -p dags
mkdir -p plugins
echo "✓ Directories created"

# Check Docker
echo ""
echo "Checking Docker..."
if command -v docker &> /dev/null; then
    echo "✓ Docker is installed"
    
    # Start Docker services
    echo ""
    read -p "Do you want to start Docker services now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Starting Docker services..."
        docker-compose up -d
        echo "✓ Docker services started"
        echo ""
        echo "Services available at:"
        echo "  - Kafdrop (Kafka UI): http://localhost:9000"
        echo "  - MinIO Console: http://localhost:9001"
        echo "  - Airflow: http://localhost:8080"
    fi
else
    echo "⚠ Docker is not installed. Please install Docker to continue."
fi

echo ""
echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Edit .env file with your API keys and credentials"
echo "2. Start Docker services: docker-compose up -d"
echo "3. Run producer: python producer/producer.py"
echo "4. Run consumer: python consumer/consumer.py"
echo ""
echo "For detailed instructions, see SETUP.md"
echo ""
