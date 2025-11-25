import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

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
        BlocProvider(
          create: (_) => sl<FieldsCubit>()..loadAllFields(),
        ),
        BlocProvider(
          create: (_) => sl<SuperAdminCubit>(),
        ),
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
            // Refresh fields list
            context.read<FieldsCubit>().loadAllFields();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              _buildProfileHeader(context),

              const SizedBox(height: 16),

              // Action Buttons
              _buildActionButtons(context),

              const SizedBox(height: 24),

              // Assigned Fields Section
              _buildAssignedFieldsSection(context),

              const SizedBox(height: 24),

              // Statistics Section
              _buildStatisticsSection(context),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              _getInitials(admin.fullName),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            admin.fullName ?? admin.email,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  admin.role == 'super_admin'
                      ? Icons.verified_user
                      : Icons.admin_panel_settings,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  admin.role == 'super_admin' ? 'Super Admin' : 'Field Owner',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Contact Info
          _buildContactInfo(Icons.email, admin.email, Colors.white),
          if (admin.phone != null && admin.phone!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildContactInfo(Icons.phone, admin.phone!, Colors.white),
          ],

          const SizedBox(height: 12),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: admin.isActive
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: admin.isActive ? Colors.green : Colors.red,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: admin.isActive ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  admin.isActive ? 'Active Account' : 'Inactive Account',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: admin.isActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Member Since
          Text(
            'Member since ${DateFormat('MMM d, y').format(admin.createdAt)}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: color.withValues(alpha: 0.95),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _showAssignFieldDialog(context);
              },
              icon: const Icon(Icons.add_business),
              label: const Text('Assign Field'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: admin.role == 'super_admin'
                  ? null
                  : () {
                      // Future: Implement deactivate/activate
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Activate/Deactivate feature coming soon',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
              icon: Icon(admin.isActive ? Icons.block : Icons.check_circle),
              label: Text(admin.isActive ? 'Deactivate' : 'Activate'),
              style: OutlinedButton.styleFrom(
                foregroundColor: admin.isActive ? Colors.red : Colors.green,
                side: BorderSide(
                  color: admin.isActive ? Colors.red : Colors.green,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedFieldsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Assigned Fields',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  _showAssignFieldDialog(context);
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Assign'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<FieldsCubit, FieldsState>(
            builder: (context, state) {
              if (state is FieldsLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is FieldsLoaded) {
                // Filter fields owned by this admin
                final adminFields = state.fields
                    .where((field) => field.ownerId == admin.id)
                    .toList();

                if (adminFields.isEmpty) {
                  return _buildEmptyFields(context);
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: adminFields.length,
                  itemBuilder: (context, index) {
                    return _buildFieldCard(context, adminFields[index]);
                  },
                );
              }

              return _buildEmptyFields(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFieldCard(BuildContext context, FieldEntity field) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/field-details',
            arguments: field.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Field Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                  image: field.mainImage != null
                      ? DecorationImage(
                          image: NetworkImage(field.mainImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: field.mainImage == null
                    ? const Icon(
                        Icons.sports_soccer,
                        size: 30,
                        color: Colors.grey,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Field Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          field.city,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.event,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${field.totalBookings} bookings',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: field.isActive
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: field.isActive ? Colors.green : Colors.orange,
                  ),
                ),
                child: Text(
                  field.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: field.isActive ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFields(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.sports_soccer_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          const Text(
            'No Fields Assigned',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This admin doesn\'t have any fields assigned yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              _showAssignFieldDialog(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Assign First Field'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<FieldsCubit, FieldsState>(
            builder: (context, state) {
              if (state is FieldsLoaded) {
                final adminFields = state.fields
                    .where((field) => field.ownerId == admin.id)
                    .toList();

                final totalFields = adminFields.length;
                final activeFields =
                    adminFields.where((f) => f.isActive).length;
                final totalBookings = adminFields.fold<int>(
                  0,
                  (sum, field) => sum + field.totalBookings,
                );
                final avgRating = adminFields
                        .where((f) => f.averageRating != null)
                        .isEmpty
                    ? 0.0
                    : adminFields
                            .where((f) => f.averageRating != null)
                            .map((f) => f.averageRating!)
                            .reduce((a, b) => a + b) /
                        adminFields.where((f) => f.averageRating != null).length;

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Fields',
                            totalFields.toString(),
                            Icons.sports_soccer,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Active Fields',
                            activeFields.toString(),
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Bookings',
                            totalBookings.toString(),
                            Icons.event,
                            Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Avg Rating',
                            avgRating > 0
                                ? avgRating.toStringAsFixed(1)
                                : 'N/A',
                            Icons.star,
                            Colors.amber,
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

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAssignFieldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<SuperAdminCubit>(),
          ),
          BlocProvider.value(
            value: context.read<FieldsCubit>(),
          ),
        ],
        child: _AssignFieldDialog(admin: admin),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}

/// Assign Field Dialog
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
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Field Dropdown
            BlocBuilder<FieldsCubit, FieldsState>(
              builder: (context, state) {
                if (state is FieldsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is FieldsLoaded) {
                  // Get fields NOT owned by THIS admin
                  // Allows reassigning from other admins OR assigning unassigned
                  final availableFields = state.fields
                      .where((field) => field.ownerId != widget.admin.id)
                      .toList();

                  if (availableFields.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.blue),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'All fields assigned',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'All available fields are already assigned to this admin.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Separate into unassigned vs assigned to others
                  final unassignedFields = availableFields
                      .where((f) => f.ownerId == null)
                      .toList();
                  final assignedToOthers = availableFields
                      .where((f) => f.ownerId != null)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedFieldId,
                        decoration: InputDecoration(
                          labelText: 'Select Field',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.sports_soccer),
                          helperText: assignedToOthers.isNotEmpty
                              ? '${assignedToOthers.length} field(s) currently assigned to other admins'
                              : null,
                          helperMaxLines: 2,
                        ),
                        items: [
                          // Unassigned fields first
                          ...unassignedFields.map((field) {
                            return DropdownMenuItem(
                              value: field.id,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${field.name} (${field.city})',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.green.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Available',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          // Divider if we have both types
                          if (unassignedFields.isNotEmpty &&
                              assignedToOthers.isNotEmpty)
                            const DropdownMenuItem(
                              enabled: false,
                              value: null,
                              child: Divider(),
                            ),
                          // Fields assigned to other admins
                          ...assignedToOthers.map((field) {
                            return DropdownMenuItem(
                              value: field.id,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${field.name} (${field.city})',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.orange.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Reassign',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedFieldId = value;
                          });
                        },
                      ),
                      // Show warning if reassigning
                      if (selectedFieldId != null &&
                          assignedToOthers.any((f) => f.id == selectedFieldId))
                        ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.orange.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber,
                                color: Colors.orange,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'This will reassign the field from its current owner to ${widget.admin.fullName ?? widget.admin.email}.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                }

                return const Text('Failed to load fields');
              },
            ),

            const SizedBox(height: 16),

            // Notes Field
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.note),
                hintText: 'Add any notes about this assignment',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading
              ? null
              : () {
                  Navigator.pop(context);
                },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading || selectedFieldId == null
              ? null
              : () {
                  _handleAssignField(context);
                },
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Assign Field'),
        ),
      ],
    );
  }

  Future<void> _handleAssignField(BuildContext context) async {
    if (selectedFieldId == null) return;

    setState(() {
      isLoading = true;
    });

    context.read<SuperAdminCubit>().assignField(
          adminId: widget.admin.id,
          fieldId: selectedFieldId!,
          notes: notesController.text.trim().isEmpty
              ? null
              : notesController.text.trim(),
        );

    // Wait a bit for the operation to complete
    await Future.delayed(const Duration(milliseconds: 500));

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
