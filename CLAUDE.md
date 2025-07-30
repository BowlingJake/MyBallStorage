# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

StrikeTrack is a Flutter app for bowling enthusiasts to manage their ball arsenal and track training sessions. The app uses Supabase for backend services, Riverpod for state management, and follows a feature-driven architecture.

## Essential Development Commands

```bash
# Install dependencies
flutter pub get

# Code generation (required after modifying Freezed/Riverpod files)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run

# Run tests
flutter test

# Analyze code (uses very_good_analysis)
flutter analyze

# Check for unused packages
flutter pub deps --no-dev

# Clean build files
flutter clean
```

## Architecture & Code Structure

### Feature-Driven Architecture
The project follows a strict 3-layer architecture per feature:

```
lib/features/{feature_name}/
├── data/           # Repository layer - all Supabase interactions
├── logic/          # Business logic - Riverpod providers
└── presentation/   # UI layer - screens and widgets
```

### Key Architecture Rules
1. **Repository Pattern**: All Supabase interactions must go through Repository classes in the `data/` layer
2. **Riverpod State Management**: Use `@riverpod` code generation for all providers. Prefer `AsyncNotifierProvider` for async operations
3. **Freezed Models**: All data models and state classes must use Freezed with code generation
4. **Separation of Concerns**: UI components should only read/watch state and call provider methods - no business logic in widgets

### Main Features
- `arsenal/` - Ball collection management
- `training/` - Training session tracking with scoring
- `ball_library/` - Browse available bowling balls
- `auth/` - User authentication
- `user/` - User profile management

## Important Technical Details

### State Management Patterns
- Use `@riverpod` annotations for all providers
- Providers should be small and focused on single responsibilities
- Use `AsyncNotifierProvider` for operations involving Supabase calls
- State classes must be immutable using Freezed

### Supabase Integration
- Never access Supabase client directly from UI or logic layers
- All database operations must go through Repository classes
- Environment variables are managed via `.env` file with flutter_dotenv

### Code Style
- Uses `very_good_analysis` linting rules
- File names: `snake_case`
- Classes/Providers: `PascalCase`
- Variables/functions: `camelCase`
- Always use curly braces for control structures
- Prefer `try-catch` for error handling

### Cursor Rules Integration
The project has specific Cursor rules that emphasize:
- Reading `AI_CONTEXT.md` and `docs/TECHNICAL_SPEC.md` before making changes
- Concise, direct responses without unnecessary explanations
- Modern, clean code generation

## Dependencies & Packages

### Core Dependencies
- `flutter_riverpod` - State management with code generation
- `supabase_flutter` - Backend services
- `go_router` - Navigation with named routes
- `freezed` + `json_serializable` - Immutable models
- `shared_preferences` - Local storage
- `flutter_dotenv` - Environment variables

### Custom Package
- `core_theme` (local package) - App theming system

## Testing
- Unit tests in `test/` directory
- Uses `mocktail` for mocking
- Test files should mirror the `lib/` structure

## Development Workflow
1. Always run code generation after modifying Freezed or Riverpod files
2. Follow the 3-layer architecture strictly
3. Ensure all Supabase interactions go through repositories
4. Run `flutter analyze` before committing
5. Check the `docs/TECHNICAL_SPEC.md` for detailed architectural guidelines