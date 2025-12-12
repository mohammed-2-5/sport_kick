import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spo_kick/features/settings/presentation/widgets/dialogs/date_format_option_tile.dart';

/// Date Format Selector Dialog
///
/// Dialog for selecting preferred date format.
class DateFormatSelectorDialog extends StatelessWidget {
  final UserPreferencesEntity preferences;

  const DateFormatSelectorDialog({required this.preferences, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Date Format'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DateFormatOptionTile(
            label: 'DD/MM/YYYY',
            example: 'e.g., 25/12/2025',
            format: DateFormatOption.ddMMyyyy,
            isSelected: preferences.dateFormat == DateFormatOption.ddMMyyyy,
            onTap: () {
              context.read<SettingsCubit>().updateDateFormat(
                preferences,
                DateFormatOption.ddMMyyyy,
              );
              Navigator.pop(context);
            },
          ),
          DateFormatOptionTile(
            label: 'MM/DD/YYYY',
            example: 'e.g., 12/25/2025',
            format: DateFormatOption.mmDdYyyy,
            isSelected: preferences.dateFormat == DateFormatOption.mmDdYyyy,
            onTap: () {
              context.read<SettingsCubit>().updateDateFormat(
                preferences,
                DateFormatOption.mmDdYyyy,
              );
              Navigator.pop(context);
            },
          ),
          DateFormatOptionTile(
            label: 'YYYY-MM-DD',
            example: 'e.g., 2025-12-25',
            format: DateFormatOption.yyyyMmDd,
            isSelected: preferences.dateFormat == DateFormatOption.yyyyMmDd,
            onTap: () {
              context.read<SettingsCubit>().updateDateFormat(
                preferences,
                DateFormatOption.yyyyMmDd,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
