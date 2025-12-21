import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/utils/currency_formatter.dart';
import 'package:spo_kick/core/utils/date_formatter.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_state.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/language_selector_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/system_preferences_date_tile.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/system_preferences_currency_tile.dart';

/// Premium system preferences section.
///
/// Displays date format and currency settings with actual values
/// from SettingsCubit. Each setting opens a selector dialog.
class PremiumSystemPreferencesSection extends StatelessWidget {
  const PremiumSystemPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final isLoading = state is SettingsLoading || state is SettingsInitial;
        final isUpdating = state is SettingsUpdating;

        String dateFormatValue = 'DD/MM/YYYY';
        String currencyValue = 'EGP (Eś)';
        String languageValue = context.l10n.loading;
        UserPreferencesEntity? preferences;

        if (state is SettingsLoaded) {
          preferences = state.preferences;
          dateFormatValue = DateFormatter.getDateFormatLabel(
            state.preferences.dateFormat,
          );
          currencyValue = CurrencyFormatter.getCurrencyLabel(
            state.preferences.currency,
          );
          languageValue = _languageLabel(context, state.preferences.language);
        } else if (state is SettingsUpdated) {
          preferences = state.preferences;
          dateFormatValue = DateFormatter.getDateFormatLabel(
            state.preferences.dateFormat,
          );
          currencyValue = CurrencyFormatter.getCurrencyLabel(
            state.preferences.currency,
          );
          languageValue = _languageLabel(context, state.preferences.language);
        }

        return PremiumSettingsSection(
          title: context.l10n.systemPreferences,
          icon: Icons.tune,
          isSaving: isUpdating,
          children: [
            SystemPreferencesDateTile(
              value: isLoading ? 'Loading...' : dateFormatValue,
              preferences: preferences,
              isEnabled: !isLoading && preferences != null,
            ),
            SystemPreferencesCurrencyTile(
              value: isLoading ? 'Loading...' : currencyValue,
              preferences: preferences,
              isEnabled: !isLoading && preferences != null,
            ),
            PremiumSettingsTile(
              label: context.l10n.language,
              value: isLoading ? context.l10n.loading : languageValue,
              icon: Icons.language,
              iconColor: Colors.purple,
              onTap: isLoading || preferences == null
                  ? null
                  : () => showDialog(
                      context: context,
                      builder: (dialogContext) => BlocProvider.value(
                        value: context.read<SettingsCubit>(),
                        child: LanguageSelectorDialog(
                          preferences: preferences!,
                        ),
                      ),
                    ),
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
}
