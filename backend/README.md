# Mistrix Backend

A Dart REST API for the Mistrix Flutter application. It uses Shelf, JWT bearer
authentication, BCrypt password hashing, and repository abstractions.

## Run locally

```bash
cd backend
dart pub get
dart run bin/server.dart
```

The server starts at `http://localhost:8080` by default.

## Environment

Set the variables shown in `.env.example` in your shell or deployment platform.
Always replace `JWT_SECRET` in production.

## Endpoints

| Method | Endpoint | Authentication |
|---|---|---|
| GET | `/health` | No |
| POST | `/api/v1/auth/signup` | No |
| POST | `/api/v1/auth/login` | No |
| GET | `/api/v1/auth/me` | Bearer token |
| GET | `/api/v1/technicians` | No |
| GET | `/api/v1/technicians/<id>` | No |
| GET | `/api/v1/bookings` | Bearer token |
| POST | `/api/v1/bookings` | Bearer token |

Technicians accept optional `query`, `profession`, and `available` query parameters.

## Architecture

Each feature separates domain entities/contracts, data implementations, and HTTP
presentation handlers. In-memory repositories are used for development; replace
them with database-backed implementations without changing routes or services.
