import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Shows a confirmation dialog before deleting a field.
Future<void> showDeleteFieldDialog({
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
        CustomButton(
          text: context.l10n.delete,
          onPressed: () {
            Navigator.pop(dialogContext);
            cubit.deleteField(field.id);
          },
          variant: ButtonVariant.primary,
        ),
      ],
    ),
  );
}
