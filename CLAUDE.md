# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Flutter library/helper project** (`dartwing_flutter_common`) that provides shared functionality, components, and utilities for the main DartWing mobile application. The main Flutter application (`dartwing_flutter_frontend`) is located one level up at `../dartwing_flutter_frontend/`.

**Important:** This is NOT a standalone Flutter application - it's a shared library used by the main app.

### Project Relationship
- **Main App:** `../dartwing_flutter_frontend/` (contains pubspec.yaml, main.dart, etc.)
- **This Library:** `./dartwing_flutter_common/` (shared code, no pubspec.yaml)

### Key Directories

- `/core/` - Core utilities and data models
  - `/data/` - Data models with JSON serialization (`*.g.dart` files are generated)
  - `globals.dart` - Global application state
  - `persistent_storage.dart` - Local storage management
  - `custom_exceptions.dart` - Custom exception types

- `/network/` - Network and API clients
  - `/dart_wing/` - DartWing API specific implementations
  - `/healthcare/` - Healthcare API integration (supports Frappe)
  - `base_api.dart` - Base API class with authentication headers
  - `rest_client.dart` - HTTP client wrapper
  - `paper_trail.dart` - Papertrail integration

- `/gui/` - Reusable UI components
  - `/widgets/` - Custom Flutter widgets
  - `/organization/` - Organization management pages
  - `/images/` - Image assets
  - `scanner_page.dart` - Barcode scanner implementation
  - `dialogs.dart` - Common dialog utilities
  - `base_apps_routers.dart` - Routing definitions

- `/localization/` - Internationalization support

## Development Commands

### Flutter Commands (Run from main app directory)
```bash
# Get dependencies
cd ../dartwing_flutter_frontend && flutter pub get

# Analyze code for issues
cd ../dartwing_flutter_frontend && flutter analyze

# Run tests
cd ../dartwing_flutter_frontend && flutter test

# Generate JSON serialization code (.g.dart files)
cd ../dartwing_flutter_frontend && flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
cd ../dartwing_flutter_frontend && flutter run

# Build for release
cd ../dartwing_flutter_frontend && flutter build apk  # Android
cd ../dartwing_flutter_frontend && flutter build ios  # iOS
```

### Git Workflow
- Current branch: `develop`
- Main branch for PRs: `main`
- Commit messages follow format: `#TICKET_NUMBER Description`

## Architecture Patterns

### JSON Serialization
- Models use `json_annotation` and `json_serializable` packages
- Generated files (`*.g.dart`) handle JSON conversion
- Example pattern in `/network/dart_wing/data/` and `/core/data/`

### Network Layer
- All API clients extend `BaseNetworkApi`
- Authentication handled via Bearer/Token headers in base class
- Custom exception handling with typed exceptions
- REST client manages HTTP operations

### State Management
- Global state stored in `Globals` class
- Keycloak integration for authentication (currently commented out)
- Application info and user data managed globally

### UI Navigation
- Route definitions in `base_apps_routers.dart`
- Named routes with JSON-encoded arguments
- Scanner page supports both barcode scanning and manual input

## Key Dependencies
- `keycloak_wrapper` - Authentication
- `mobile_scanner` - Barcode scanning
- `json_annotation`/`json_serializable` - JSON handling
- `http` - Network requests
- `crypto` - Cryptographic operations

## Code Generation
When modifying models with `@JsonSerializable`:
1. Update the model class
2. Run build_runner to regenerate `.g.dart` files
3. Commit both the model and generated files