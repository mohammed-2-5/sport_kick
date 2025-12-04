import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_action_buttons.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_empty_fields_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_field_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_profile_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/admin_details/admin_stats_card.dart';

/// Admin Details Page
///
/// Comprehensive view of a field owner (admin) account showing:
/// - Profile information
/// - Assigned fields
/// - Performance statistics
/// - Actions (Assign Field, Deactivate/Activate)
class AdminDetailsPage extends StatelessWidget {
  final UserEntity admin;

  const AdminDetailsPage({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<FieldsCubit>()..loadAllFields()),
        BlocProvider(create: (_) => sl<SuperAdminCubit>()),
      ],
      child: _AdminDetailsView(admin: admin),
    );
  }
}

class _AdminDetailsView extends StatelessWidget {
  final UserEntity admin;

  const _AdminDetailsView({required this.admin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Details'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<FieldsCubit>().loadAllFields();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocListener<SuperAdminCubit, SuperAdminState>(
        listener: (context, state) {
          if (state is SuperAdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state is FieldAssigned) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Field assigned successfully'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<FieldsCubit>().loadAllFields();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              AdminProfileHeader(admin: admin),

              const SizedBox(height: AdminUIConstants.spacingMedium),

              // Action Buttons
              AdminActionButtons(
                admin: admin,
                onAssignField: () => _showAssignFieldDialog(context),
                onToggleStatus: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Activate/Deactivate feature coming soon'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              const SizedBox(height: AdminUIConstants.spacingLarge),

              // Assigned Fields Section
              _buildAssignedFieldsSection(context),

              const SizedBox(height: AdminUIConstants.spacingLarge),

              // Statistics Section
              _buildStatisticsSection(context),

              const SizedBox(height: AdminUIConstants.spacingLarge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignedFieldsSection(BuildContext context) {
    return Padding(
      padding: AdminUIConstants.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Assigned Fields',
                style: TextStyle(
                  fontSize: AdminUIConstants.fontSizeXLarge,
                  fontWeight: AdminUIConstants.fontWeightBold,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAssignFieldDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Assign'),
              ),
            ],
          ),
          const SizedBox(height: AdminUIConstants.listItemSpacing),
          BlocBuilder<FieldsCubit, FieldsState>(
            builder: (context, state) {
              if (state is FieldsLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AdminUIConstants.emptyStatePadding),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is FieldsLoaded) {
                final adminFields = state.fields
                    .where((field) => field.ownerId == admin.id)
                    .toList();

                if (adminFields.isEmpty) {
                  return AdminEmptyFieldsState(
                    onAssignField: () => _showAssignFieldDialog(context),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: adminFields.length,
                  itemBuilder: (context, index) {
                    return AdminFieldCard(
                      field: adminFields[index],
                      onTap: () {
                        context.pushNamed(
                          'fieldDetails',
                          pathParameters: {'fieldId': adminFields[index].id},
                        );
                      },
                    );
                  },
                );
              }

              return AdminEmptyFieldsState(
                onAssignField: () => _showAssignFieldDialog(context),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return Padding(
      padding: AdminUIConstants.paddingHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              fontSize: AdminUIConstants.fontSizeXLarge,
              fontWeight: AdminUIConstants.fontWeightBold,
            ),
          ),
          const SizedBox(height: AdminUIConstants.listItemSpacing),
          BlocBuilder<FieldsCubit, FieldsState>(
            builder: (context, state) {
              if (state is FieldsLoaded) {
                final adminFields = state.fields
                    .where((field) => field.ownerId == admin.id)
                    .toList();

                final totalFields = adminFields.length;
                final activeFields = adminFields
                    .where((f) => f.isActive)
                    .length;
                final totalBookings = adminFields.fold<int>(
                  0,
                  (sum, field) => sum + field.totalBookings,
                );
                final avgRating =
                    adminFields.where((f) => f.averageRating != null).isEmpty
                    ? 0.0
                    : adminFields
                              .where((f) => f.averageRating != null)
                              .map((f) => f.averageRating!)
                              .reduce((a, b) => a + b) /
                          adminFields
                              .where((f) => f.averageRating != null)
                              .length;

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AdminStatsCard(
                            label: 'Total Fields',
                            value: totalFields.toString(),
                            icon: Icons.sports_soccer,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: AdminUIConstants.listItemSpacing),
                        Expanded(
                          child: AdminStatsCard(
                            label: 'Active Fields',
                            value: activeFields.toString(),
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AdminUIConstants.listItemSpacing),
                    Row(
                      children: [
                        Expanded(
                          child: AdminStatsCard(
                            label: 'Total Bookings',
                            value: totalBookings.toString(),
                            icon: Icons.event,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(width: AdminUIConstants.listItemSpacing),
                        Expanded(
                          child: AdminStatsCard(
                            label: 'Avg Rating',
                            value: avgRating > 0
                                ? avgRating.toStringAsFixed(1)
                                : 'N/A',
                            icon: Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  void _showAssignFieldDialog(BuildContext context) {
    // Note: The _AssignFieldDialog widget remains in this file
    // as it's specific to this page and quite large (300+ lines)
    // It could be extracted later if needed
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<SuperAdminCubit>()),
          BlocProvider.value(value: context.read<FieldsCubit>()),
        ],
        child: _AssignFieldDialog(admin: admin),
      ),
    );
  }
}

/// Assign Field Dialog
/// TODO: Extract to separate file if needed
class _AssignFieldDialog extends StatefulWidget {
  final UserEntity admin;

  const _AssignFieldDialog({required this.admin});

  @override
  State<_AssignFieldDialog> createState() => _AssignFieldDialogState();
}

class _AssignFieldDialogState extends State<_AssignFieldDialog> {
  String? selectedFieldId;
  final notesController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Assign Field to Admin'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assigning to: ${widget.admin.fullName ?? widget.admin.email}',
              style: TextStyle(
                fontSize: AdminUIConstants.fontSizeMedium,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: AdminUIConstants.spacingMedium),

            // Field Dropdown
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
                    return Container(
                      padding: AdminUIConstants.paddingAll,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(
                          alpha: AdminUIConstants.opacityLight,
                        ),
                        borderRadius: AdminUIConstants.borderRadiusMedium,
                        border: Border.all(
                          color: Colors.blue.withValues(
                            alpha: AdminUIConstants.opacityMedium,
                          ),
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.blue),
                              SizedBox(width: AdminUIConstants.listItemSpacing),
                              Expanded(
                                child: Text(
                                  'All Available Fields Assigned',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AdminUIConstants.spacingSmall),
                          Text(
                            'This admin already has all available fields assigned.',
                            style: TextStyle(
                              fontSize: AdminUIConstants.fontSizeSmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return DropdownButtonFormField<String>(
                    initialValue: selectedFieldId,
                    decoration: const InputDecoration(
                      labelText: 'Select Field',
                      border: OutlineInputBorder(),
                    ),
                    items: availableFields.map((field) {
                      return DropdownMenuItem(
                        value: field.id,
                        child: Text(field.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedFieldId = value);
                    },
                  );
                }

                return const Text('Unable to load fields');
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: selectedFieldId == null || isLoading
              ? null
              : () {
                  setState(() => isLoading = true);
                  context.read<SuperAdminCubit>().assignField(
                    fieldId: selectedFieldId!,
                    adminId: widget.admin.id,
                  );
                  Navigator.pop(context);
                },
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Assign'),
        ),
      ],
    );
  }
}
