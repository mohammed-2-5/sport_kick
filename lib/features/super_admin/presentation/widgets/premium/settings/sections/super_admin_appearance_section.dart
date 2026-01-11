import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_state.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/language_selector_dialog.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/theme_selector_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_tile.dart';

/// Appearance section for super admin settings.
///
/// Handles theme and language selection for super admins.
class SuperAdminAppearanceSection extends StatelessWidget {
  const SuperAdminAppearanceSection({super.key});

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
        final themeValue = preferences == null
            ? context.l10n.loading
            : _themeModeLabel(context, preferences.themeMode);
        final languageValue = preferences == null
            ? context.l10n.loading
            : _languageLabel(context, preferences.language);

        return PremiumSettingsSection(
          title: context.l10n.appearance,
          icon: Icons.palette_outlined,
          children: [
            PremiumSettingsTile(
              label: context.l10n.theme,
              value: isLoading ? context.l10n.loading : themeValue,
              icon: Icons.brightness_6,
              iconColor: Colors.amber,
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
            PremiumSettingsTile(
              label: context.l10n.language,
              value: isLoading ? context.l10n.loading : languageValue,
              icon: Icons.language,
              iconColor: Colors.blue,
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

  String _languageLabel(BuildContext context, String code) {
    switch (code) {
      case SettingsConstants.languageArabic:
        return context.l10n.languageArabic;
      case SettingsConstants.languageEnglish:
      default:
        return context.l10n.languageEnglish;
    }
  }
}
