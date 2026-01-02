import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';

/// Theme Selector Dialog
///
/// Dialog for selecting app theme (Light/Dark/System).
class ThemeSelectorDialog extends StatelessWidget {
  final UserPreferencesEntity preferences;

  const ThemeSelectorDialog({required this.preferences, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.chooseTheme),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ThemeOptionTile(
            label: context.l10n.themeLight,
            icon: Icons.light_mode,
            mode: AppThemeMode.light,
            isSelected: preferences.themeMode == AppThemeMode.light,
            onSelected: () => _selectTheme(context, AppThemeMode.light),
          ),
          _ThemeOptionTile(
            label: context.l10n.themeDark,
            icon: Icons.dark_mode,
            mode: AppThemeMode.dark,
            isSelected: preferences.themeMode == AppThemeMode.dark,
            onSelected: () => _selectTheme(context, AppThemeMode.dark),
          ),
          _ThemeOptionTile(
            label: context.l10n.themeSystem,
            icon: Icons.settings_suggest,
            mode: AppThemeMode.system,
            isSelected: preferences.themeMode == AppThemeMode.system,
            onSelected: () => _selectTheme(context, AppThemeMode.system),
          ),
        ],
      ),
    );
  }

  void _selectTheme(BuildContext context, AppThemeMode mode) {
    context.read<SettingsCubit>().updateThemeMode(preferences, mode);
    Navigator.pop(context);
  }
}

/// Individual theme option tile
class _ThemeOptionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final AppThemeMode mode;
  final bool isSelected;
  final VoidCallback onSelected;

  const _ThemeOptionTile({
    required this.label,
    required this.icon,
    required this.mode,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colorScheme.primary : colorScheme.onSurface,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colorScheme.primary)
          : Icon(Icons.circle_outlined, color: colorScheme.outline),
      onTap: onSelected,
    );
  }
}
