import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';

/// Shows a confirmation dialog before deleting a field.
Future<void> showDeleteFieldDialog({
  required BuildContext context,
  required FieldEntity field,
}) async {
  final cubit = context.read<OwnerCubit>();

  await showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Field'),
      content: Text(
        'Are you sure you want to delete "${field.name}"? '
        'This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        CustomButton(
          text: 'Delete',
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
