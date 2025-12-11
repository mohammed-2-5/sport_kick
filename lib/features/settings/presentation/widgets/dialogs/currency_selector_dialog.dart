import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';

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
          _buildCurrencyOption(
            context,
            'Egyptian Pound',
            'EGP (E£)',
            CurrencyOption.egp,
            preferences.currency == CurrencyOption.egp,
          ),
          _buildCurrencyOption(
            context,
            'US Dollar',
            'USD (\$)',
            CurrencyOption.usd,
            preferences.currency == CurrencyOption.usd,
          ),
          _buildCurrencyOption(
            context,
            'Euro',
            'EUR (€)',
            CurrencyOption.eur,
            preferences.currency == CurrencyOption.eur,
          ),
          _buildCurrencyOption(
            context,
            'Saudi Riyal',
            'SAR (﷼)',
            CurrencyOption.sar,
            preferences.currency == CurrencyOption.sar,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyOption(
    BuildContext context,
    String label,
    String code,
    CurrencyOption currency,
    bool isSelected,
  ) {
    return RadioListTile<CurrencyOption>(
      title: Text(label),
      subtitle: Text(
        code,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
      value: currency,
      groupValue: preferences.currency,
      onChanged: (value) {
        if (value != null) {
          context.read<SettingsCubit>().updateCurrency(preferences, value);
          Navigator.pop(context);
        }
      },
    );
  }
}
