import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/widgets/settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/settings_tile.dart';
import 'package:spo_kick/features/settings/presentation/widgets/theme_selector_dialog.dart';
import 'package:spo_kick/features/settings/presentation/widgets/language_selector_dialog.dart';

/// Appearance settings section for user settings page.
/// Includes theme and language selection.
class AppearanceSettingsSection extends StatelessWidget {
  final UserPreferencesEntity preferences;

  const AppearanceSettingsSection({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        SettingsTile(
          leading: const Icon(Icons.brightness_6, color: AppColors.primary),
          title: 'Theme',
          subtitle: SettingsConstants
              .themeModeNames[_themeModeToString(preferences.themeMode)]!,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeDialog(context),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.language, color: AppColors.info),
          title: 'Language',
          subtitle:
              SettingsConstants.languageNames[preferences.language] ??
              'English',
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(context),
        ),
      ],
    );
  }

  String _themeModeToString(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ThemeSelectorDialog(preferences: preferences),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LanguageSelectorDialog(preferences: preferences),
    );
  }
}
