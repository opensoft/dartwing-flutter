# GitHub Copilot Prompt: Create New Repository for DartWing Flutter Common Library

## Repository Details

**Repository Name:** `dartwing-flutter-common`  
**Organization/Owner:** [Specify your GitHub organization or username]  
**Visibility:** Private (or Public based on your needs)  
**Description:** Shared Flutter library providing common utilities, UI components, and API integrations for the DartWing mobile application ecosystem

## Repository Configuration

### Basic Setup
- **License:** [Specify license type, e.g., MIT, Apache 2.0, or proprietary]
- **Initialize with README:** No (we'll push existing content)
- **.gitignore:** Flutter
- **Default Branch:** `main`

### Branch Protection Rules
Set up branch protection for `main`:
- Require pull request reviews before merging (1 approver minimum)
- Require status checks to pass before merging
- Require branches to be up to date before merging
- Include administrators in restrictions

### Repository Topics/Tags
Add the following topics for discoverability:
- `flutter`
- `dart`
- `mobile-library`
- `dartwing`
- `shared-library`
- `healthcare-api`
- `frappe-integration`

## Project Description

### Overview
This is a **Flutter shared library** (not a standalone application) that provides reusable components and utilities for the main DartWing mobile application. The library contains:

**Core Functionality:**
- Global state management
- Persistent storage utilities
- Custom exception handling
- Application configuration and settings

**Network Layer:**
- DartWing API client with authentication
- Healthcare/Frappe API integration (Patient, Doctor/Healthcare Practitioner, DISH models)
- User management API
- SharePoint integration
- Base REST client with bearer token authentication
- Papertrail logging integration

**UI Components:**
- Reusable widgets and base scaffolds
- Organization management pages
- Barcode scanner implementation
- Common dialogs and notifications
- Navigation/routing utilities
- Multi-language support (English, German)

### Technical Stack
- **Language:** Dart
- **Framework:** Flutter
- **Key Dependencies:**
  - `keycloak_wrapper` - Authentication
  - `mobile_scanner` - Barcode scanning
  - `json_serializable` - JSON serialization
  - `http` - Network requests
  
### Architecture
- JSON serialization with code generation (`*.g.dart` files)
- Base API classes with shared authentication
- Modular network clients (DartWing API, Healthcare/Frappe API, Users API)
- Internationalization support
- DevContainer configuration for consistent development environment

## Migration Instructions

### Current State
- **Current Host:** Azure DevOps (FarHeapSolutions/DartWing/flutter_lib)
- **Current Remote:** `git@vs-ssh.visualstudio.com:v3/FarHeapSolutions/DartWing/flutter_lib`
- **Active Branches:**
  - `main` - Initial/stable branch (commit: 40f9c20)
  - `develop` - Active development branch (48 commits ahead of main)

### Required Actions

1. **Create the GitHub repository** with the settings above

2. **Add these files to the new repository:**
   - Migrate comprehensive `.gitignore` for Flutter projects
   - Create proper README.md (replace template README)
   - Include CLAUDE.md for AI assistant context
   - Add CONTRIBUTING.md guidelines
   - Add LICENSE file

3. **Set up GitHub Actions workflows** (in `.github/workflows/`):
   - `code-quality.yml` - Run `flutter analyze` on PRs
   - `build-runner.yml` - Verify JSON serialization code generation
   - `branch-protection.yml` - Enforce develop → main PR workflow

4. **Configure GitHub Issues:**
   - Enable issue templates for bug reports and feature requests
   - Add labels: `bug`, `enhancement`, `documentation`, `api`, `ui`, `healthcare`, `good-first-issue`

5. **Project Board Setup:**
   - Create a project board with columns: Backlog, In Progress, Review, Done
   - Link to the main DartWing application project if applicable

6. **Documentation to Add:**
   - API documentation for network clients
   - Widget usage examples
   - Development setup guide (with devcontainer instructions)
   - Code generation guide for JSON models
   - Integration guide for the main application

## README Template Content

Include these sections in the new README.md:
1. **Project Overview** - Explain this is a shared library for DartWing apps
2. **Features** - List core, network, and GUI capabilities
3. **Installation** - How to include this library in a Flutter project
4. **Development Setup** - DevContainer usage, Flutter setup
5. **Architecture** - Folder structure explanation
6. **Code Generation** - How to regenerate JSON serialization code
7. **API Documentation** - Links to API client documentation
8. **Contributing** - PR workflow, coding standards
9. **Related Projects** - Link to main `dartwing-flutter-frontend` repository
10. **License** - License information

## Post-Migration Steps

After creating the repository and pushing code:

1. **Update remote URLs** in local repository:
   ```bash
   git remote add github git@github.com:[ORG]/dartwing-flutter-common.git
   git push github develop
   git push github main
   ```

2. **Protect the develop branch** similarly to main

3. **Create initial issues** for:
   - Documentation improvements
   - Code coverage setup
   - CI/CD pipeline completion
   - API documentation generation

4. **Team Access:**
   - Add team members with appropriate permissions
   - Configure CODEOWNERS file for automatic review assignments

5. **Integration:**
   - Update references in main application's documentation
   - Add repository as a dependency in the main app

## Notes

- This library works in conjunction with `dartwing_flutter_frontend` (main application)
- Current development follows ticket-based commits: `#TICKET_NUMBER Description`
- Recent work focuses on healthcare API integration and URL migrations
- DevContainer configured for user `brett` (UID: 1000, GID: 1000)
- Ports 3000 and 8080 forwarded for development

## Questions to Answer Before Creation

1. GitHub organization name or personal account?
2. Public or private repository?
3. License type?
4. Should we maintain Azure DevOps as secondary remote?
5. Naming convention: `dartwing-flutter-common` or `dartwing_flutter_common` or `flutter-common-lib`?
