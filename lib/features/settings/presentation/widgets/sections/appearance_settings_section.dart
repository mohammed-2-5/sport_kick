import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/currency_formatter.dart';
import 'package:spo_kick/core/utils/date_formatter.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_tile.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/currency_selector_dialog.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/date_format_selector_dialog.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/theme_selector_dialog.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/language_selector_dialog.dart';

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
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.calendar_today, color: AppColors.secondary),
          title: 'Date Format',
          subtitle: DateFormatter.getDateFormatLabel(preferences.dateFormat),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showDateFormatDialog(context),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: const Icon(Icons.attach_money, color: AppColors.success),
          title: 'Currency',
          subtitle: CurrencyFormatter.getCurrencyLabel(preferences.currency),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showCurrencyDialog(context),
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

  void _showDateFormatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DateFormatSelectorDialog(preferences: preferences),
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CurrencySelectorDialog(preferences: preferences),
    );
  }
}
