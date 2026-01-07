# Dark Theme Pattern Guide

This document describes the dark theme implementation pattern used in Sport Kick app.

## Architecture Overview

```
ThemeCubit (State Management)
    ↓
MaterialApp (themeMode: state.themeMode)
    ↓
Theme.of(context).colorScheme (Access in widgets)
```

## Core Files

| File | Purpose |
|------|---------|
| `lib/core/theme/theme_cubit.dart` | Theme state management |
| `lib/core/theme/theme_state.dart` | Theme state definitions |
| `lib/core/constants/app_theme.dart` | Light/Dark ThemeData definitions |
| `lib/core/constants/app_colors.dart` | Color palette with dark variants |

---

## Pattern 1: Basic Theme-Aware Widget

```dart
@override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Container(
    color: colorScheme.surface,           // Background
    child: Text(
      'Hello',
      style: TextStyle(
        color: colorScheme.onSurface,     // Text on surface
      ),
    ),
  );
}
```

## Pattern 2: With Semantic Colors (Success/Error/Warning)

```dart
@override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  // Semantic colors
  final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
  final errorColor = isDark ? AppColors.darkError : AppColors.error;
  final warningColor = isDark ? AppColors.darkWarning : AppColors.warning;
  final infoColor = isDark ? AppColors.darkInfo : AppColors.info;

  return Container(
    color: successColor,
    child: Text('Success', style: TextStyle(color: Colors.white)),
  );
}
```

## Pattern 3: Nested Widget Without Context

When a private widget doesn't have direct access to context in build:

```dart
Widget _buildLabel() {
  return Builder(
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      return Text(
        'Label',
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      );
    },
  );
}
```

---

## Color Mapping Reference

### Replace These Old Colors:

| Old (Don't Use) | New (Use This) |
|-----------------|----------------|
| `AppColors.textPrimary` | `colorScheme.onSurface` |
| `AppColors.textSecondary` | `colorScheme.onSurfaceVariant` |
| `AppColors.backgroundLight` | `colorScheme.surface` |
| `AppColors.backgroundDark` | `colorScheme.surfaceContainerHighest` |
| `AppColors.border` | `colorScheme.outline` |
| `Colors.white` (for backgrounds) | `colorScheme.surface` |
| `Colors.black` (for text) | `colorScheme.onSurface` |
| `Colors.grey` | `colorScheme.onSurfaceVariant` |

### Semantic Colors (Require isDark Check):

| Color Type | Light Mode | Dark Mode |
|------------|------------|-----------|
| Success | `AppColors.success` | `AppColors.darkSuccess` |
| Error | `AppColors.error` | `AppColors.darkError` |
| Warning | `AppColors.warning` | `AppColors.darkWarning` |
| Info | `AppColors.info` | `AppColors.darkInfo` |

### ColorScheme Properties:

| Property | Usage |
|----------|-------|
| `colorScheme.primary` | Primary brand color |
| `colorScheme.onPrimary` | Text/icons on primary |
| `colorScheme.secondary` | Secondary accent |
| `colorScheme.surface` | Card/container backgrounds |
| `colorScheme.onSurface` | Primary text |
| `colorScheme.onSurfaceVariant` | Secondary/muted text |
| `colorScheme.outline` | Borders, dividers |
| `colorScheme.surfaceContainerHighest` | Elevated surfaces |
| `colorScheme.error` | Error states |

---

## How to Update app_colors.dart

### Adding New Semantic Colors

1. Add the light mode color:
```dart
static const Color myNewColor = Color(0xFF...);
```

2. Add the dark mode variant:
```dart
static const Color darkMyNewColor = Color(0xFF...);
```

3. Use in widgets:
```dart
final myColor = isDark ? AppColors.darkMyNewColor : AppColors.myNewColor;
```

### Color Guidelines for Dark Mode

- **Dark backgrounds**: Use colors with low brightness (10-20%)
- **Dark text**: Use white with 87% opacity for primary, 60% for secondary
- **Accent colors**: Slightly desaturate and brighten for dark mode
- **Shadows**: Reduce opacity or remove in dark mode
- **Borders**: Use subtle outlines instead of shadows

---

## Examples

### Card Widget
```dart
class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            'Title',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Subtitle',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
```

### Status Badge
```dart
class StatusBadge extends StatelessWidget {
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
    final errorColor = isDark ? AppColors.darkError : AppColors.error;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isSuccess ? successColor : errorColor).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isSuccess ? 'Active' : 'Inactive',
        style: TextStyle(
          color: isSuccess ? successColor : errorColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
```

### Gradient on Colored Background (Keep White)
```dart
// When text is on a gradient/colored background, white is intentional
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.primary, AppColors.primaryDark],
    ),
  ),
  child: Text(
    'White text on gradient',
    style: TextStyle(color: Colors.white), // OK - intentional
  ),
)
```

---

## Checklist for New Widgets

- [ ] Use `Theme.of(context).colorScheme` for colors
- [ ] Add `isDark` check for semantic colors (success/error/warning/info)
- [ ] Replace hardcoded `Colors.white/black` with colorScheme equivalents
- [ ] Replace `AppColors.textPrimary/textSecondary` with colorScheme
- [ ] Test in both light and dark modes
- [ ] Ensure sufficient contrast for text readability

---

## Testing Dark Mode

1. Toggle in app settings
2. Or use system dark mode
3. Check all screens for:
   - Text readability
   - Proper contrast
   - No pure white/black backgrounds
   - Semantic colors visible
