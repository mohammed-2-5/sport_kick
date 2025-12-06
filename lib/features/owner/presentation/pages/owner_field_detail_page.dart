import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/app_error_widget.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/utils/delete_field_dialog.dart';
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
            onPressed: () =>
                context.pushNamed('ownerEditField', extra: widget.field),
            tooltip: 'Edit field',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () =>
                showDeleteFieldDialog(context: context, field: widget.field),
            tooltip: 'Delete field',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<OwnerCubit, OwnerState>(
        listener: (context, state) {
          if (state is OwnerError) {
            SnackbarHelper.showError(context, state.message);
          } else if (state is OwnerActionSuccess) {
            SnackbarHelper.showSuccess(context, state.message);
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
}
