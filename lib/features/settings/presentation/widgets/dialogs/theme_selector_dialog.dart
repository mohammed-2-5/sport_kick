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
          _buildThemeOption(
            context,
            'Light',
            AppThemeMode.light,
            preferences.themeMode == AppThemeMode.light,
          ),
          _buildThemeOption(
            context,
            'Dark',
            AppThemeMode.dark,
            preferences.themeMode == AppThemeMode.dark,
          ),
          _buildThemeOption(
            context,
            'System Default',
            AppThemeMode.system,
            preferences.themeMode == AppThemeMode.system,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String label,
    AppThemeMode mode,
    bool isSelected,
  ) {
    // ignore: deprecated_member_use
    return RadioListTile<AppThemeMode>(
      title: Text(label),
      value: mode,
      // ignore: deprecated_member_use
      groupValue: preferences.themeMode,
      // ignore: deprecated_member_use
      onChanged: (value) {
        if (value != null) {
          context.read<SettingsCubit>().updateThemeMode(preferences, value);
          Navigator.pop(context);
        }
      },
    );
  }
}
