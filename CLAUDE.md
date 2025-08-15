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

### UI Components Standards
- **Buttons**: Always use `AppStandardButton` from `lib/shared/widgets/common/buttons/app_standard_button.dart` following our design system:
  * **主要動作 (Primary)**: `AppStandardButton()` - 金色實心，用於確認/提交/完成流程
  * **次要動作 (Secondary)**: `AppStandardButton.secondary()` - 白色線框，用於取消/返回/查看詳情
  * **創造功能 (Creative)**: `AppStandardButton.creative()` - 青色實心，用於新增/創建/特殊功能
  * **破壞性動作 (Destructive)**: `AppStandardButton.destructive()` - 紅色實心，用於刪除/清除等不可逆操作
- **Dropdowns**: Always use `CustomDropdownButton` from `lib/shared/widgets/dropdowns/custom_dropdown_button.dart` unless explicitly told to use another dropdown
- **Notifications**: 
  * **NEVER use SnackBar, ScaffoldMessenger, or any bottom notifications**
  * Always use `TopNotification` from `lib/shared/widgets/common/notifications/top_notification.dart` for ALL user notifications
  * Use `TopNotification.showSuccess(context, message)` for success messages (green)
  * Use `TopNotification.showError(context, message)` for error messages (red)
  * Examples:
    ```dart
    // ✅ 正確 - 使用 TopNotification
    TopNotification.showSuccess(context, 'Layout updated successfully');
    TopNotification.showError(context, 'Failed to update layout');
    
    // ❌ 錯誤 - 不要使用 SnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(...));
    ```

### Mobile-First UI/UX Design Principles
This is a **mobile application** - all UI/UX design decisions must prioritize mobile user experience:

1. **Touch-First Interactions**:
   - All scrollable content must support touch scrolling with proper physics (`BouncingScrollPhysics`)
   - Use `ListView.builder` for long lists to ensure smooth scrolling performance
   - Implement proper touch targets (minimum 44px tap area)
   - Support swipe gestures where appropriate

2. **Dialog & Modal Design**:
   - All dialogs must be scrollable when content exceeds screen height
   - Use `ConstrainedBox` with `maxHeight: MediaQuery.of(context).size.height * 0.6-0.8` for content areas
   - Implement `ScrollConfiguration` with touch device support for all scrollable areas
   - Hide scrollbars (`scrollbars: false`) while maintaining scroll functionality
   - Use `Flexible` widgets in dialogs to prevent overflow

3. **Mobile Layout Patterns**:
   - Design for portrait orientation first
   - Use responsive layouts that adapt to different screen sizes
   - Implement bottom sheets for secondary actions when appropriate
   - Consider thumb-reachable areas for primary actions

4. **Performance on Mobile**:
   - Use `ListView.builder` instead of Column with many children
   - Implement lazy loading for large datasets
   - Optimize image loading and caching
   - Minimize unnecessary rebuilds with proper state management

5. **Accessibility**:
   - Provide semantic labels for screen readers
   - Ensure sufficient color contrast
   - Support system font scaling
   - Test with accessibility features enabled

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