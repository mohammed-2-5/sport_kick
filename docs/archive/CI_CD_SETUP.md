# CI/CD Setup Guide

## Overview
Automated code quality checks have been configured for the Sport Kick project using GitHub Actions and pre-commit hooks.

## What's Been Set Up

### 1. Enhanced Analysis Options (`analysis_options.yaml`)
- **40+ strict linting rules** enforced
- **Error severity levels** configured
- **Implicit casts disabled** for type safety
- **Deprecated member warnings** enabled

### 2. GitHub Actions Workflow (`.github/workflows/code_quality.yml`)
Runs automatically on:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`

**Checks performed:**
- ✅ Code formatting verification
- ✅ Static analysis (`flutter analyze`)
- ✅ Unit tests (`flutter test`)
- ✅ Debug APK build

### 3. Pre-commit Hooks (`.githooks/pre-commit`)
Runs locally before each commit:
- ✅ Code formatting check
- ✅ Static analysis

## Setup Instructions

### Enable Pre-commit Hooks
Run this command once in your project directory:

```bash
git config core.hooksPath .githooks
```

On Windows (PowerShell):
```powershell
git config core.hooksPath .githooks
```

### Make Hook Executable (Linux/Mac)
```bash
chmod +x .githooks/pre-commit
```

## Usage

### Local Development
1. Write your code
2. Run `flutter format .` to format code
3. Run `flutter analyze` to check for issues
4. Commit your changes (pre-commit hook runs automatically)

### Bypass Pre-commit Hook (Not Recommended)
```bash
git commit --no-verify -m "your message"
```

## CI/CD Pipeline

### On Pull Request
1. Code is checked out
2. Flutter dependencies installed
3. Formatting verified
4. Static analysis run
5. Tests executed
6. Build validated

### Viewing Results
- Check the "Actions" tab in GitHub
- PR will show ✅ or ❌ status
- Click "Details" to see specific failures

## Linting Rules Enforced

### Error Prevention
- No empty else blocks
- No print statements in production
- Proper null safety
- Valid regular expressions

### Code Style
- Const constructors preferred
- Single quotes for strings
- Proper naming conventions
- Unnecessary code removed

## Troubleshooting

### Pre-commit Hook Not Running
```bash
# Verify hook path
git config core.hooksPath

# Re-set if needed
git config core.hooksPath .githooks
```

### Analysis Failures
```bash
# Run locally to see issues
flutter analyze

# Auto-fix some issues
dart fix --apply
```

### Formatting Issues
```bash
# Format all files
flutter format .

# Check without modifying
flutter format --set-exit-if-changed .
```

## Next Steps
- All new code must pass CI/CD checks
- Existing code will be refactored to meet standards
- Regular updates to linting rules as needed
