import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/date_format_selector_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/settings/premium_settings_tile.dart';

/// System preferences date format tile.
///
/// Displays current date format and opens selector dialog on tap.
class SystemPreferencesDateTile extends StatelessWidget {
  final String value;
  final UserPreferencesEntity? preferences;
  final bool isEnabled;

  const SystemPreferencesDateTile({
    required this.value,
    required this.preferences,
    required this.isEnabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumSettingsTile(
      label: context.l10n.dateFormat,
      value: value,
      icon: Icons.calendar_today,
      iconColor: Colors.blue,
      onTap: isEnabled
          ? () => showDialog(
              context: context,
              builder: (dialogContext) => BlocProvider.value(
                value: context.read<SettingsCubit>(),
                child: DateFormatSelectorDialog(preferences: preferences!),
              ),
            )
          : null,
    );
  }
}
