import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';

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
          _buildFormatOption(
            context,
            'DD/MM/YYYY',
            'e.g., 25/12/2025',
            DateFormatOption.ddMMyyyy,
            preferences.dateFormat == DateFormatOption.ddMMyyyy,
          ),
          _buildFormatOption(
            context,
            'MM/DD/YYYY',
            'e.g., 12/25/2025',
            DateFormatOption.mmDdYyyy,
            preferences.dateFormat == DateFormatOption.mmDdYyyy,
          ),
          _buildFormatOption(
            context,
            'YYYY-MM-DD',
            'e.g., 2025-12-25',
            DateFormatOption.yyyyMmDd,
            preferences.dateFormat == DateFormatOption.yyyyMmDd,
          ),
        ],
      ),
    );
  }

  Widget _buildFormatOption(
    BuildContext context,
    String label,
    String example,
    DateFormatOption format,
    bool isSelected,
  ) {
    return RadioListTile<DateFormatOption>(
      title: Text(label),
      subtitle: Text(
        example,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
      value: format,
      groupValue: preferences.dateFormat,
      onChanged: (value) {
        if (value != null) {
          context.read<SettingsCubit>().updateDateFormat(preferences, value);
          Navigator.pop(context);
        }
      },
    );
  }
}
