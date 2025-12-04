import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/app_error_widget.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_detail_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_detail_stats.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_recent_bookings.dart';

/// Owner field detail page - shows detailed field information for owners.
///
/// Displays:
/// - Field image gallery and basic info
/// - Field statistics (bookings, revenue, rating)
/// - Recent bookings for this field
/// - Edit and delete actions
class OwnerFieldDetailPage extends StatefulWidget {
  final FieldEntity field;

  const OwnerFieldDetailPage({super.key, required this.field});

  @override
  State<OwnerFieldDetailPage> createState() => _OwnerFieldDetailPageState();
}

class _OwnerFieldDetailPageState extends State<OwnerFieldDetailPage> {
  @override
  void initState() {
    super.initState();
    _loadFieldBookings();
  }

  void _loadFieldBookings() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<OwnerCubit>().loadOwnerBookings(ownerId: authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditField(),
            tooltip: 'Edit field',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteConfirmation(),
            tooltip: 'Delete field',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<OwnerCubit, OwnerState>(
        listener: (context, state) {
          if (state is OwnerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is OwnerActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Reload bookings after action
            _loadFieldBookings();
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async => _loadFieldBookings(),
            child: CustomScrollView(
              slivers: [
                // Field Header (Image Gallery)
                SliverToBoxAdapter(
                  child: FieldDetailHeader(field: widget.field),
                ),

                // Field Statistics
                SliverToBoxAdapter(
                  child: FieldDetailStats(field: widget.field),
                ),

                // Recent Bookings Section
                if (state is OwnerBookingsLoaded)
                  SliverToBoxAdapter(
                    child: FieldRecentBookings(
                      fieldId: widget.field.id,
                      bookings: state.bookings,
                    ),
                  )
                else if (state is OwnerLoading)
                  const SliverFillRemaining(
                    child: LoadingIndicator.inline(
                      message: 'Loading bookings...',
                    ),
                  )
                else if (state is OwnerError)
                  SliverFillRemaining(
                    child: AppErrorWidget(
                      message: state.message,
                      onRetry: _loadFieldBookings,
                    ),
                  ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToEditField() {
    context.pushNamed('ownerEditField', extra: widget.field);
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Field'),
        content: Text(
          'Are you sure you want to delete "${widget.field.name}"? '
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
              _deleteField();
            },
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  void _deleteField() {
    context.read<OwnerCubit>().deleteField(widget.field.id);
  }
}
