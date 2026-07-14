# Mistrix Flutter Frontend

The Flutter mobile application for customers and administrators of the Mistrix
local technician marketplace.

## Clean Architecture

```text
lib/
  core/                         # Shared constants, theme and widgets
  features/
    admin/                      # Admin entities, repository and management UI
    auth/                       # Login and signup presentation
    bookings/                   # Booking domain, data and presentation layers
    home/                       # Customer home shell and navigation
    onboarding/                 # Landing screens
    technicians/                # Technician domain, data and presentation layers
  injection_container.dart      # Dependency composition
  app.dart                      # Application routes and role-based flow
  main.dart                     # Flutter entry point
```

Feature dependencies point inward: presentation depends on domain contracts,
while data implementations satisfy those contracts.

## Run

From the repository root:

```bash
cd frontend
flutter pub get
flutter run
```

## Backend

The Dart REST API is in `../backend`. See `../backend/README.md` for its setup and
endpoint documentation.
