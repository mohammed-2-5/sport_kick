import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/currency_option_tile.dart';

/// Currency Selector Dialog
///
/// Dialog for selecting preferred currency.
class CurrencySelectorDialog extends StatelessWidget {
  final UserPreferencesEntity preferences;

  const CurrencySelectorDialog({required this.preferences, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Currency'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CurrencyOptionTile(
            label: 'Egyptian Pound',
            code: 'EGP (E£)',
            currency: CurrencyOption.egp,
            isSelected: preferences.currency == CurrencyOption.egp,
            onTap: () {
              context.read<SettingsCubit>().updateCurrency(
                preferences,
                CurrencyOption.egp,
              );
              Navigator.pop(context);
            },
          ),
          CurrencyOptionTile(
            label: 'US Dollar',
            code: 'USD (\$)',
            currency: CurrencyOption.usd,
            isSelected: preferences.currency == CurrencyOption.usd,
            onTap: () {
              context.read<SettingsCubit>().updateCurrency(
                preferences,
                CurrencyOption.usd,
              );
              Navigator.pop(context);
            },
          ),
          CurrencyOptionTile(
            label: 'Euro',
            code: 'EUR (€)',
            currency: CurrencyOption.eur,
            isSelected: preferences.currency == CurrencyOption.eur,
            onTap: () {
              context.read<SettingsCubit>().updateCurrency(
                preferences,
                CurrencyOption.eur,
              );
              Navigator.pop(context);
            },
          ),
          CurrencyOptionTile(
            label: 'Saudi Riyal',
            code: 'SAR (﷼)',
            currency: CurrencyOption.sar,
            isSelected: preferences.currency == CurrencyOption.sar,
            onTap: () {
              context.read<SettingsCubit>().updateCurrency(
                preferences,
                CurrencyOption.sar,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
