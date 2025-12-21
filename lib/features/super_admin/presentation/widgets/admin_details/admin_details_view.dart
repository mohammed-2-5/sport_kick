import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_action_buttons.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_assigned_fields_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_profile_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_statistics_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/assign_field_dialog.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Admin Details View - displays admin information with all sections.
///
/// Uses SnackbarHelper for feedback and delegates to section widgets.
class AdminDetailsView extends StatelessWidget {
  final UserEntity admin;

  const AdminDetailsView({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.adminDetails),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<FieldsCubit>().loadAllFields(),
            tooltip: context.l10n.refresh,
          ),
        ],
      ),
      body: BlocListener<SuperAdminCubit, SuperAdminState>(
        listener: (context, state) {
          if (state is SuperAdminError) {
            SnackbarHelper.showError(context, state.message);
          } else if (state is FieldAssigned) {
            SnackbarHelper.showSuccess(context, 'Field assigned successfully');
            context.read<FieldsCubit>().loadAllFields();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminProfileHeader(admin: admin),
              const SizedBox(height: AdminUIConstants.spacingMedium),
              AdminActionButtons(
                admin: admin,
                onAssignField: () =>
                    showAssignFieldDialog(context: context, admin: admin),
                onToggleStatus: () {
                  SnackbarHelper.showInfo(
                    context,
                    'Activate/Deactivate feature coming soon',
                  );
                },
              ),
              const SizedBox(height: AdminUIConstants.spacingLarge),
              AdminAssignedFieldsSection(
                admin: admin,
                onAssignField: () =>
                    showAssignFieldDialog(context: context, admin: admin),
              ),
              const SizedBox(height: AdminUIConstants.spacingLarge),
              AdminStatisticsSection(admin: admin),
              const SizedBox(height: AdminUIConstants.spacingLarge),
            ],
          ),
        ),
      ),
    );
  }
}
