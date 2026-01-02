import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Dialog for assigning a field to an admin.
class AssignFieldDialog extends StatefulWidget {
  final UserEntity admin;

  const AssignFieldDialog({super.key, required this.admin});

  @override
  State<AssignFieldDialog> createState() => _AssignFieldDialogState();
}

class _AssignFieldDialogState extends State<AssignFieldDialog> {
  String? selectedFieldId;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.assignFieldToAdmin),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.assigningTo(
                widget.admin.fullName ?? widget.admin.email,
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AdminUIConstants.spacingMedium),
            BlocBuilder<FieldsCubit, FieldsState>(
              builder: (context, state) {
                if (state is FieldsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is FieldsLoaded) {
                  final availableFields = state.fields
                      .where((field) => field.ownerId != widget.admin.id)
                      .toList();

                  if (availableFields.isEmpty) {
                    return _buildAllAssignedMessage();
                  }

                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: context.l10n.selectField,
                      border: const OutlineInputBorder(),
                    ),
                    items: availableFields.map((field) {
                      return DropdownMenuItem(
                        value: field.id,
                        child: Text(field.name),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => selectedFieldId = value),
                  );
                }

                return Text(context.l10n.unableToLoadFields);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        ElevatedButton(
          onPressed: selectedFieldId == null || isLoading ? null : _assignField,
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.l10n.assign),
        ),
      ],
    );
  }

  Widget _buildAllAssignedMessage() {
    return Container(
      padding: AdminUIConstants.paddingAll,
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: AdminUIConstants.opacityLight),
        borderRadius: AdminUIConstants.borderRadiusMedium,
        border: Border.all(
          color: Colors.blue.withValues(alpha: AdminUIConstants.opacityMedium),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.blue),
              const SizedBox(width: AdminUIConstants.listItemSpacing),
              Expanded(
                child: Text(
                  context.l10n.allAvailableFieldsAssigned,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AdminUIConstants.spacingSmall),
          Text(
            context.l10n.thisAdminAlreadyHasAllAvailable,
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  void _assignField() {
    setState(() => isLoading = true);
    context.read<SuperAdminCubit>().assignField(
      fieldId: selectedFieldId!,
      adminId: widget.admin.id,
    );
    Navigator.pop(context);
  }
}

/// Shows the assign field dialog with proper bloc providers.
void showAssignFieldDialog({
  required BuildContext context,
  required UserEntity admin,
}) {
  showDialog(
    context: context,
    builder: (dialogContext) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<SuperAdminCubit>()),
        BlocProvider.value(value: context.read<FieldsCubit>()),
      ],
      child: AssignFieldDialog(admin: admin),
    ),
  );
}
