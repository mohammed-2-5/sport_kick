# Comfortable Premium Design System

This design system aims for a "Quiet Luxury" aesthetic. It avoids harsh neons and high-contrast blacks in favor of deep matte charcoal, soft slate, and sophisticated muted gold or bronze accents. The goal is to be easy on the eyes while feeling extremely premium.

## Color Palette

### Dark Mode (Primary)
- **Background**: `#121212` (Deep Matte Charcoal) - Not pure black, softer on OLED screens.
- **Surface**: `#1E1E1E` (Dark Grey) - For cards and elevated elements.
- **Surface Highlight**: `#2C2C2C` (Soft Grey) - For active states or inputs.
- **Primary Accent**: `#D4AF37` (Muted Gold) - Used sparingly for key actions and branding.
- **Secondary Accent**: `#A5A6F6` (Soft Periwinkle) - For secondary actions or notifications.
- **Text Primary**: `#E1E1E1` (Off-White) - High readability without glare.
- **Text Secondary**: `#A0A0A0` (Medium Grey) - For subtitles and hints.

### Light Mode (Secondary)
- **Background**: `#F5F5F7` (Soft Cloud White) - Warm, not sterile.
- **Surface**: `#FFFFFF` (Pure White) - With soft shadows.
- **Primary Accent**: `#1A1C1E` (Dark Slate) - High contrast, professional.
- **Secondary Accent**: `#D4AF37` (Muted Gold) - Retains the premium feel.

## Typography
- **Headings**: 'Outfit' or 'Inter' (Bold, Tight tracking).
- **Body**: 'Inter' or 'Roboto' (Regular, Relaxed line height).

## UI Elements
- **Cards**: Rounded corners (16px), subtle borders (1px solid #333), soft drop shadows.
- **Buttons**: Pill-shaped or soft rounded rects (12px). Gradient fills are subtle, not harsh.
- **Icons**: Thin stroke (1.5px), elegant.

## Implementation Plan
1.  Update `AppColors` in `lib/core/constants/app_colors.dart`.
2.  Update `AppTheme` in `lib/core/constants/app_theme.dart` to support this Dark Mode.
3.  Apply `ThemeData.dark()` as the default or an option.
