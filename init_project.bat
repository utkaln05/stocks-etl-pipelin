@echo off
REM Real-Time Stocks Pipeline - Project Initialization Script for Windows

echo =========================================
echo Real-Time Stocks Pipeline Setup
echo =========================================
echo.

REM Check if .env exists
if not exist .env (
    echo Creating .env file from template...
    copy .env.example .env
    echo [OK] .env file created. Please edit it with your credentials.
) else (
    echo [OK] .env file already exists
)

REM Create virtual environment
if not exist venv (
    echo.
    echo Creating Python virtual environment...
    python -m venv venv
    echo [OK] Virtual environment created
) else (
    echo [OK] Virtual environment already exists
)

REM Activate virtual environment and install dependencies
echo.
echo Installing Python dependencies...
call venv\Scripts\activate.bat
pip install -r requirements.txt
echo [OK] Dependencies installed

REM Create necessary directories
echo.
echo Creating necessary directories...
if not exist logs mkdir logs
if not exist dags mkdir dags
if not exist plugins mkdir plugins
echo [OK] Directories created

REM Check Docker
echo.
echo Checking Docker...
docker --version >nul 2>&1
if %errorlevel% == 0 (
    echo [OK] Docker is installed
    
    REM Start Docker services
    echo.
    set /p answer="Do you want to start Docker services now? (y/n): "
    if /i "%answer%"=="y" (
        echo Starting Docker services...
        docker-compose up -d
        echo [OK] Docker services started
        echo.
        echo Services available at:
        echo   - Kafdrop (Kafka UI^): http://localhost:9000
        echo   - MinIO Console: http://localhost:9001
        echo   - Airflow: http://localhost:8080
    )
) else (
    echo [WARNING] Docker is not installed. Please install Docker to continue.
)

echo.
echo =========================================
echo Setup Complete!
echo =========================================
echo.
echo Next steps:
echo 1. Edit .env file with your API keys and credentials
echo 2. Start Docker services: docker-compose up -d
echo 3. Run producer: python producer/producer.py
echo 4. Run consumer: python consumer/consumer.py
echo.
echo For detailed instructions, see SETUP.md
echo.
pause
