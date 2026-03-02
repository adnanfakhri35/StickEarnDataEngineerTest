# StickEarn_DataEngineer_Test
This repository is created for StickEarn Data Engineer Test Submission.

## Prerequisites

Make sure Docker Desktop is installed:

https://docs.docker.com/engine/install/

After installation, verify Docker is installed correctly:

```bash
docker --version
```

---

## Steps to Run the Project

1. Open Docker Desktop.

2. Clone this repository:

```bash
git clone https://github.com/adnanfakhri35/StickEarnDataEngineerTest
cd StickEarn_DataEngineer_Test
```

3. Stop and remove any existing containers and volumes:

```bash
docker compose down -v
```

4. Build and start all services:

```bash
docker compose up -d --build
```

5. Check if containers are running:

```bash
docker ps
```

6. Check Python logs to see if the script is running:

```bash
docker compose logs -f etl
```

---

## Running ClickHouse Client

If needed, access ClickHouse client:

```bash
docker exec -it ch-dev clickhouse-client -u dev --password dev123
```

Check the table:

```sql
SELECT * FROM default.mobility_events;
```

---

## Stopping the Services

To stop all services:

```bash
docker compose down
```

To stop and remove volumes:

```bash
docker compose down -v
```

Created and written by Kemas M. Adnan Fakhri Sjaf Fawwaz
