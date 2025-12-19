import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/localization/app_locale_cubit.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';
import 'package:spo_kick/features/settings/presentation/constants/settings_constants.dart';
import 'package:spo_kick/features/settings/presentation/cubit/settings_cubit.dart';

/// Language Selector Dialog
///
/// Dialog for selecting app language.
class LanguageSelectorDialog extends StatelessWidget {
  final UserPreferencesEntity preferences;

  const LanguageSelectorDialog({required this.preferences, super.key});

  @override
  Widget build(BuildContext context) {
    final languageOptions = {
      SettingsConstants.languageEnglish: context.l10n.languageEnglish,
      SettingsConstants.languageArabic: context.l10n.languageArabic,
    };

    return AlertDialog(
      title: Text(context.l10n.language),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: languageOptions.entries.map((entry) {
          return RadioListTile<String>(
            title: Text(entry.value),
            value: entry.key,
            // ignore: deprecated_member_use
            groupValue: preferences.language,
            // ignore: deprecated_member_use
            onChanged: (value) {
              if (value != null) {
                context.read<AppLocaleCubit>().setLocale(value);
                context.read<SettingsCubit>().updateLanguage(
                  preferences,
                  value,
                );
                Navigator.pop(context);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
