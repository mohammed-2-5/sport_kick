import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Shows a confirmation dialog before deleting a field from the owner fields list.
Future<void> showDeleteFieldConfirmation({
  required BuildContext context,
  required FieldEntity field,
}) async {
  final cubit = context.read<OwnerCubit>();

  await showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(context.l10n.deleteFieldTitle),
      content: Text(context.l10n.deleteFieldMessage(field.name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            cubit.deleteField(field.id);
          },
          child: Text(
            context.l10n.delete,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
          ),
        ),
      ],
    ),
  );
}
