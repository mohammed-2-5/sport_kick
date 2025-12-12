import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/utils/currency_formatter.dart';
import 'package:spo_kick/core/utils/date_formatter.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_section.dart';
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
    return BlocProvider(
      create: (_) {
        final cubit = sl<SettingsCubit>();
        final authState = context.read<AuthCubit>().state;
        if (authState is Authenticated) {
          cubit.loadPreferences(authState.user.id);
        }
        return cubit;
      },
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final isLoading = state is SettingsLoading;
          final isUpdating = state is SettingsUpdating;

          String dateFormatValue = 'DD/MM/YYYY';
          String currencyValue = 'EGP (E£)';
          UserPreferencesEntity? preferences;

          if (state is SettingsLoaded) {
            preferences = state.preferences;
            dateFormatValue = DateFormatter.getDateFormatLabel(
              state.preferences.dateFormat,
            );
            currencyValue = CurrencyFormatter.getCurrencyLabel(
              state.preferences.currency,
            );
          } else if (state is SettingsUpdated) {
            preferences = state.preferences;
            dateFormatValue = DateFormatter.getDateFormatLabel(
              state.preferences.dateFormat,
            );
            currencyValue = CurrencyFormatter.getCurrencyLabel(
              state.preferences.currency,
            );
          }

          return PremiumSettingsSection(
            title: 'System Preferences',
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
            ],
          );
        },
      ),
    );
  }
}
