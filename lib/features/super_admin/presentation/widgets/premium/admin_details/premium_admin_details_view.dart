import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_details/admin_details_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_details/admin_details_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_details/premium_admin_action_buttons.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_details/premium_admin_fields_list.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_details/premium_admin_profile_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_details/premium_admin_stats_grid.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/admin_details/premium_assign_field_dialog.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/user_details/premium_status_toggle_dialog.dart';

/// Premium admin details view.
///
/// Features:
/// - Premium profile header with gold theme
/// - Statistics grid
/// - Assigned fields list
/// - Action buttons
/// - Assign field dialog
/// - Status toggle dialog
/// - All logic handled by AdminDetailsCubit
class PremiumAdminDetailsView extends StatefulWidget {
  final UserEntity admin;

  const PremiumAdminDetailsView({super.key, required this.admin});

  @override
  State<PremiumAdminDetailsView> createState() =>
      _PremiumAdminDetailsViewState();
}

class _PremiumAdminDetailsViewState extends State<PremiumAdminDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<AdminDetailsCubit>().initialize(widget.admin);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminDetailsCubit, AdminDetailsState>(
      listener: (context, state) {
        if (state is AdminDetailsError) {
          SnackbarHelper.showError(context, state.message);
        } else if (state is FieldAssignedSuccess) {
          SnackbarHelper.showSuccess(context, state.message);
          context.read<AdminDetailsCubit>().refreshFields();
        } else if (state is AdminStatusToggled) {
          SnackbarHelper.showSuccess(context, state.message);
          // Refresh data
          context.read<AdminDetailsCubit>().initialize(state.admin);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.backgroundLight,
              body: _buildBody(context, state),
            ),

            // Assign field dialog
            if (state is AdminDetailsLoaded && state.showAssignDialog)
              PremiumAssignFieldDialog(
                availableFields: state.availableFields,
                selectedFieldId: state.selectedFieldId,
                onFieldSelected: (id) =>
                    context.read<AdminDetailsCubit>().selectField(id),
                onConfirm: () =>
                    context.read<AdminDetailsCubit>().assignSelectedField(),
                onCancel: () =>
                    context.read<AdminDetailsCubit>().hideAssignFieldDialog(),
              ),

            // Status toggle dialog
            if (state is AdminDetailsLoaded && state.showStatusDialog)
              PremiumStatusToggleDialog(
                user: state.admin,
                onConfirm: () =>
                    context.read<AdminDetailsCubit>().toggleAdminStatus(),
                onCancel: () =>
                    context.read<AdminDetailsCubit>().hideStatusToggleDialog(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AdminDetailsState state) {
    if (state is AdminDetailsLoading) {
      return const _LoadingState();
    }

    if (state is AdminDetailsError && state.admin == null) {
      return _ErrorState(
        message: state.message,
        onRetry: () =>
            context.read<AdminDetailsCubit>().initialize(widget.admin),
      );
    }

    final admin = _getAdminFromState(state);
    final stats = _getStatsFromState(state);
    final assignedFields = _getAssignedFieldsFromState(state);
    final isTogglingStatus = _getIsTogglingStatus(state);
    final isAssigningField = _getIsAssigningField(state);
    final cubit = context.read<AdminDetailsCubit>();

    return RefreshIndicator(
      onRefresh: () async => cubit.refreshFields(),
      color: AppColors.premiumGold,
      child: CustomScrollView(
        slivers: [
          // Back button
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _BackButton(onTap: () => context.pop()),
                    const Spacer(),
                    _RefreshButton(onTap: () => cubit.refreshFields()),
                  ],
                ),
              ),
            ),
          ),

          // Profile header
          SliverToBoxAdapter(
            child: PremiumAdminProfileHeader(
              admin: admin,
              memberSince: cubit.getFormattedDate(admin.createdAt),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.only(top: 20, bottom: 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Action buttons
                PremiumAdminActionButtons(
                  admin: admin,
                  isTogglingStatus: isTogglingStatus,
                  isAssigningField: isAssigningField,
                  onToggleStatus: () => cubit.showStatusToggleDialog(),
                  onAssignField: () => cubit.showAssignFieldDialog(),
                ),
                const SizedBox(height: 24),

                // Stats grid
                if (stats != null) ...[
                  PremiumAdminStatsGrid(stats: stats),
                  const SizedBox(height: 24),
                ],

                // Assigned fields
                PremiumAdminFieldsList(
                  fields: assignedFields,
                  onAssignField: () => cubit.showAssignFieldDialog(),
                  onFieldTap: (field) {
                    // Navigate to field details
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  UserEntity _getAdminFromState(AdminDetailsState state) {
    if (state is AdminDetailsLoaded) return state.admin;
    if (state is AdminStatusToggled) return state.admin;
    if (state is FieldAssignedSuccess) return state.admin;
    if (state is AdminDetailsError && state.admin != null) return state.admin!;
    return widget.admin;
  }

  AdminDetailsStats? _getStatsFromState(AdminDetailsState state) {
    if (state is AdminDetailsLoaded) return state.stats;
    return null;
  }

  List<FieldEntity> _getAssignedFieldsFromState(AdminDetailsState state) {
    if (state is AdminDetailsLoaded) return state.assignedFields;
    return [];
  }

  bool _getIsTogglingStatus(AdminDetailsState state) {
    if (state is AdminDetailsLoaded) return state.isTogglingStatus;
    return false;
  }

  bool _getIsAssigningField(AdminDetailsState state) {
    if (state is AdminDetailsLoaded) return state.isAssigningField;
    return false;
  }
}

/// Back button widget.
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
      ),
    );
  }
}

/// Refresh button widget.
class _RefreshButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RefreshButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: const Icon(Icons.refresh, color: Colors.white, size: 20),
      ),
    );
  }
}

/// Loading state widget.
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDeep, AppColors.navyLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.premiumGold),
      ),
    );
  }
}

/// Error state widget.
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDeep, AppColors.navyLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.premiumGold,
                        AppColors.premiumGoldDark,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
