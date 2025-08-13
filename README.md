# Historical Sunset & Sunrise Frontend

This is the API  historical sunset and sunrise data. You can search by location and date range to see when solar events occurred.

## 🚀 Quick Start

### Prerequisites
- Docker installed

### Installation
1. Clone the repository:
```bash
git clone https://github.com/Pedro705/api-sunset-sunrise.git
```

2. Navigate to project directory:
```bash
cd api-sunset-sunrise
```

### Running with Docker
```bash
docker compose up
```

## 🌐 Access the Endpoint
After starting, open Postman, and make the request:
```
http://localhost:3000/historical_solar_record?location=Lisbon&start_date=10/08/2025&end_date=13/08/2025
```
Nice! Everything works!

## 🐛 Troubleshooting
If you encounter issues:
```bash
docker compose down && docker compose up --build
```

## 📂 Project Structure
```
/app
  /controllers  - Endpoint controller
  /models       - Database model logic
  /services     - Services to access external information
/db
  /migrations   - Migrations to add tables to the database schema
  schema.rb     - Representation of the tables
docker-compose.yml - Container configuration
```