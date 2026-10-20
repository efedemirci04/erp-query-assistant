# ERP Query Assistant

Ask questions about a small ERP database in plain language; the assistant turns them into SQL, validates the SQL, and returns the results.

> Status: skeleton — schema design in progress.

## Stack

- Java 21, Spring Boot 4
- PostgreSQL 17 (Docker)
- Flyway for schema migrations
- JdbcClient (no ORM — generated SQL runs directly)

## Run locally

Requirements: Java 21, Maven, Docker.

```bash
docker compose up -d          # start PostgreSQL
mvn spring-boot:run           # start the API on :8080
```

Check it works:

```bash
curl localhost:8080/actuator/health
curl localhost:8080/api/db/info
```

## Roadmap

1. MVP — ERP schema + seed data, question → SQL → result
2. SQL safety layer — parse generated SQL, allow read-only queries only
3. Evaluation — test set of questions, accuracy report
4. UI — React front end with charts, Docker, CI
