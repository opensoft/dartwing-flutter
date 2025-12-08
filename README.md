# Dartwing Flutter Common

A shared Flutter library providing reusable components, utilities, and infrastructure for the DartWing mobile application ecosystem.

## Overview

Dartwing Flutter Common is not a standalone application—it's a shared library package that provides core functionality used by the main DartWing Flutter frontend application. It encapsulates common patterns, UI components, network clients, and utilities to promote code reuse and consistency across the DartWing mobile ecosystem.

## Features

### Core Utilities
- Global application state management
- Type-safe data models with JSON serialization
- Local persistent storage management
- Custom exception handling
- Application configuration management

### Network Layer
- API client abstractions for multiple backends (DartWing, Healthcare/Frappe)
- Base API class with built-in Bearer token authentication
- REST client wrapper for HTTP operations
- Centralized error handling and logging (Papertrail integration)

### Reusable UI Components
- Custom Flutter widgets
- Barcode scanner page with manual input support
- Organization management UI
- Common dialog utilities
- Routing and navigation definitions

### Internationalization
- Multi-language support infrastructure
- Localization strings management

## Project Structure

```
├── /core/              # Core utilities and data models
│   ├── /data/          # Data models with JSON serialization
│   ├── globals.dart    # Global application state
│   ├── persistent_storage.dart
│   └── custom_exceptions.dart
├── /network/           # API clients and network layer
│   ├── /dart_wing/     # DartWing API implementation
│   ├── /healthcare/    # Healthcare API integration
│   ├── base_api.dart   # Base API with authentication
│   └── rest_client.dart
├── /gui/               # Reusable UI components
│   ├── /widgets/       # Custom Flutter widgets
│   ├── /organization/  # Organization management UI
│   ├── scanner_page.dart
│   └── dialogs.dart
└── /localization/      # i18n strings and translations
```

## Getting Started

This library is used as a dependency in the main DartWing Flutter application located at `../dartwing_flutter_frontend/`.

### Development

To work on this library:

1. Navigate to the main application directory:
   ```bash
   cd ../dartwing_flutter_frontend
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Generate code (for JSON serialization models):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Key Dependencies

- `keycloak_wrapper` - Authentication
- `mobile_scanner` - Barcode scanning functionality
- `json_annotation` / `json_serializable` - Type-safe JSON handling
- `http` - Network requests
- `crypto` - Cryptographic operations

## Architecture Patterns

### Network Layer
All API clients extend `BaseNetworkApi`, which handles:
- Bearer token authentication
- Common request headers
- Centralized error handling

### JSON Serialization
Data models use `@JsonSerializable` decorator pattern:
- Models are defined in `.dart` files
- Generated serialization code in `.g.dart` files
- Regenerate after model changes using build_runner

### State Management
Global application state is managed through the `Globals` class, providing:
- User authentication data
- Application configuration
- Session information

## Git Workflow

- **Development branch:** `develop`
- **Main branch:** `main` (for pull requests)
- **Commit format:** `#TICKET_NUMBER Description`

## Contributing

When modifying data models:
1. Update the model class with appropriate `@JsonSerializable` decorators
2. Run `flutter pub run build_runner build --delete-conflicting-outputs`
3. Commit both the model and generated `.g.dart` files

Ensure changes are consistent with DartWing's architecture patterns and follow Flutter best practices.
