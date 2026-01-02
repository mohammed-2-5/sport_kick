import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_section.dart';
import 'package:spo_kick/features/settings/presentation/widgets/shared/settings_tile.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/theme_selector_dialog.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/language_selector_dialog.dart';

/// Appearance settings section for user settings page.
/// Includes theme and language selection.
class AppearanceSettingsSection extends StatelessWidget {
  final UserPreferencesEntity preferences;

  const AppearanceSettingsSection({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsSection(
      title: context.l10n.appearance,
      icon: Icons.palette_outlined,
      children: [
        SettingsTile(
          leading: Icon(Icons.brightness_6, color: colorScheme.primary),
          title: context.l10n.theme,
          subtitle: _themeModeLabel(context, preferences.themeMode),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeDialog(context),
        ),
        const SizedBox(height: SettingsConstants.itemSpacing),
        SettingsTile(
          leading: Icon(Icons.language, color: colorScheme.tertiary),
          title: context.l10n.language,
          subtitle: _languageName(context, preferences.language),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(context),
        ),
      ],
    );
  }

  String _themeModeLabel(BuildContext context, AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return context.l10n.themeLight;
      case AppThemeMode.dark:
        return context.l10n.themeDark;
      case AppThemeMode.system:
        return context.l10n.themeSystem;
    }
  }

  String _languageName(BuildContext context, String code) {
    switch (code) {
      case SettingsConstants.languageArabic:
        return context.l10n.languageArabic;
      case SettingsConstants.languageEnglish:
      default:
        return context.l10n.languageEnglish;
    }
  }

  void _showThemeDialog(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: settingsCubit,
        child: ThemeSelectorDialog(preferences: preferences),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: settingsCubit,
        child: LanguageSelectorDialog(preferences: preferences),
      ),
    );
  }
}
