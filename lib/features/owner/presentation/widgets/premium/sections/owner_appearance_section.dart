import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_owner_settings_section.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_state.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/language_selector_dialog.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/theme_selector_dialog.dart';

/// Appearance section for owner settings.
///
/// Handles theme and language selection for field owners.
class OwnerAppearanceSection extends StatelessWidget {
  const OwnerAppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        UserPreferencesEntity? preferences;
        if (state is SettingsLoaded) {
          preferences = state.preferences;
        } else if (state is SettingsUpdated) {
          preferences = state.preferences;
        } else if (state is SettingsUpdating) {
          preferences = state.currentPreferences;
        }

        final isLoading = state is SettingsLoading || state is SettingsInitial;
        final languageValue = preferences == null
            ? context.l10n.loading
            : _languageLabel(context, preferences.language);
        final themeValue = preferences == null
            ? context.l10n.loading
            : _themeModeLabel(context, preferences.themeMode);

        return PremiumOwnerSettingsSection(
          title: context.l10n.appearance,
          icon: Icons.palette_outlined,
          children: [
            OwnerSettingsTile(
              label: context.l10n.theme,
              icon: Icons.brightness_6,
              value: isLoading ? context.l10n.loading : themeValue,
              onTap: () {
                if (preferences == null) {
                  return;
                }
                HapticFeedback.lightImpact();
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: context.read<SettingsCubit>(),
                    child: ThemeSelectorDialog(preferences: preferences!),
                  ),
                );
              },
            ),
            OwnerSettingsTile(
              label: context.l10n.language,
              icon: Icons.language,
              value: isLoading ? context.l10n.loading : languageValue,
              onTap: () {
                if (preferences == null) {
                  return;
                }
                HapticFeedback.lightImpact();
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: context.read<SettingsCubit>(),
                    child: LanguageSelectorDialog(preferences: preferences!),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _languageLabel(BuildContext context, String code) {
    switch (code) {
      case SettingsConstants.languageArabic:
        return context.l10n.languageArabic;
      case SettingsConstants.languageEnglish:
      default:
        return context.l10n.languageEnglish;
    }
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
}
