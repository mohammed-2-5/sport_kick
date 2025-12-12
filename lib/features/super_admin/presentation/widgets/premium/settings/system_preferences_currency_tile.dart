import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/currency_selector_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_tile.dart';

/// System preferences currency tile.
///
/// Displays current currency and opens selector dialog on tap.
class SystemPreferencesCurrencyTile extends StatelessWidget {
  final String value;
  final UserPreferencesEntity? preferences;
  final bool isEnabled;

  const SystemPreferencesCurrencyTile({
    required this.value,
    required this.preferences,
    required this.isEnabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumSettingsTile(
      label: 'Currency',
      value: value,
      icon: Icons.attach_money,
      iconColor: Colors.green,
      onTap: isEnabled
          ? () => showDialog(
              context: context,
              builder: (dialogContext) => BlocProvider.value(
                value: context.read<SettingsCubit>(),
                child: CurrencySelectorDialog(preferences: preferences!),
              ),
            )
          : null,
    );
  }
}
