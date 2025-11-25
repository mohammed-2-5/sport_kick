import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_status.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_cubit.dart';
import 'package:spo_kick/features/bookings/presentation/cubit/booking_state.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';

/// User Details Page
///
/// Comprehensive view of a customer (user) account showing:
/// - Profile information
/// - Booking history
/// - Statistics
/// - Actions (Activate/Deactivate)
class UserDetailsPage extends StatelessWidget {
  final UserEntity user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<BookingCubit>()..loadUserBookings(),
        ),
        BlocProvider(
          create: (_) => sl<SuperAdminCubit>(),
        ),
      ],
      child: _UserDetailsView(user: user),
    );
  }
}

class _UserDetailsView extends StatefulWidget {
  final UserEntity user;

  const _UserDetailsView({required this.user});

  @override
  State<_UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<_UserDetailsView> {
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<BookingCubit>().loadUserBookings();
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

          if (state is UserActivated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User activated successfully'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Update local user state
            setState(() {
              currentUser = currentUser.copyWith(isActive: true);
            });
          }

          if (state is UserDeactivated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User deactivated successfully'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
              ),
            );
            // Update local user state
            setState(() {
              currentUser = currentUser.copyWith(isActive: false);
            });
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

              // Statistics Section
              _buildStatisticsSection(context),

              const SizedBox(height: 24),

              // Booking History Section
              _buildBookingHistorySection(context),

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
            Colors.blue,
            Colors.blue.withValues(alpha: 0.8),
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
              _getInitials(currentUser.fullName),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            currentUser.fullName ?? currentUser.email,
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
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, size: 16, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  'Customer',
                  style: TextStyle(
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
          _buildContactInfo(Icons.email, currentUser.email, Colors.white),
          if (currentUser.phone != null && currentUser.phone!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildContactInfo(Icons.phone, currentUser.phone!, Colors.white),
          ],

          const SizedBox(height: 12),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: currentUser.isActive
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: currentUser.isActive ? Colors.green : Colors.red,
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
                    color: currentUser.isActive ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  currentUser.isActive ? 'Active Account' : 'Inactive Account',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: currentUser.isActive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Member Since
          Text(
            'Member since ${DateFormat('MMM d, y').format(currentUser.createdAt)}',
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
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            _showActivateDeactivateDialog(context);
          },
          icon: Icon(currentUser.isActive ? Icons.block : Icons.check_circle),
          label: Text(
            currentUser.isActive ? 'Deactivate Account' : 'Activate Account',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                currentUser.isActive ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
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
          BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              if (state is BookingsLoaded) {
                // Filter bookings for this user
                final userBookings = state.bookings;

                final totalBookings = userBookings.length;
                final pendingBookings = userBookings
                    .where((b) => b.status == BookingStatus.pending)
                    .length;
                final confirmedBookings = userBookings
                    .where((b) => b.status == BookingStatus.confirmed)
                    .length;
                final totalSpent = userBookings
                    .where((b) =>
                        b.status == BookingStatus.confirmed ||
                        b.status == BookingStatus.completed)
                    .fold<double>(0, (sum, b) => sum + b.totalPrice);

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Bookings',
                            totalBookings.toString(),
                            Icons.event,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Pending',
                            pendingBookings.toString(),
                            Icons.schedule,
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Confirmed',
                            confirmedBookings.toString(),
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Total Spent',
                            '${totalSpent.toStringAsFixed(0)} EGP',
                            Icons.attach_money,
                            Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              return const Center(child: CircularProgressIndicator());
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

  Widget _buildBookingHistorySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              if (state is BookingLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is BookingsLoaded) {
                final userBookings = state.bookings;

                if (userBookings.isEmpty) {
                  return _buildEmptyBookings();
                }

                // Sort by date (most recent first)
                final sortedBookings = userBookings.toList()
                  ..sort((a, b) => b.date.compareTo(a.date));

                // Show only the most recent 10 bookings
                final recentBookings = sortedBookings.take(10).toList();

                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentBookings.length,
                      itemBuilder: (context, index) {
                        return _buildBookingCard(
                          context,
                          recentBookings[index],
                        );
                      },
                    ),
                    if (userBookings.length > 10) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          // Navigate to all bookings page filtered by user
                          Navigator.pushNamed(
                            context,
                            '/super-admin/bookings',
                          );
                        },
                        child: Text(
                          'View All ${userBookings.length} Bookings',
                        ),
                      ),
                    ],
                  ],
                );
              }

              return _buildEmptyBookings();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingEntity booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/booking-details',
            arguments: booking.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Booking Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getStatusIcon(booking.status),
                  color: _getStatusColor(booking.status),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Booking Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.fieldName ?? 'Unknown Field',
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
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, y').format(booking.date),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          booking.formattedTimeSlot,
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

              // Status Badge & Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getStatusColor(booking.status),
                      ),
                    ),
                    child: Text(
                      booking.status.displayName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(booking.status),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.formattedPrice,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyBookings() {
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
            Icons.event_busy,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          const Text(
            'No Bookings Yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This user hasn\'t made any bookings yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showActivateDeactivateDialog(BuildContext context) {
    final isActivating = !currentUser.isActive;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isActivating ? 'Activate User' : 'Deactivate User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isActivating
                  ? 'Are you sure you want to activate this user account?'
                  : 'Are you sure you want to deactivate this user account?',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isActivating ? Colors.green : Colors.orange)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (isActivating ? Colors.green : Colors.orange)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isActivating ? Icons.info_outline : Icons.warning_amber,
                    color: isActivating ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isActivating
                          ? 'User will be able to login and make bookings.'
                          : 'User will not be able to login or access their account.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isActivating ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'User: ${currentUser.fullName ?? currentUser.email}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (isActivating) {
                context.read<SuperAdminCubit>().activateUser(currentUser.id);
              } else {
                context.read<SuperAdminCubit>().deactivateUser(currentUser.id);
              }
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isActivating ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(isActivating ? 'Activate' : 'Deactivate'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.canceled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.purple;
    }
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.schedule;
      case BookingStatus.confirmed:
        return Icons.check_circle;
      case BookingStatus.canceled:
        return Icons.cancel;
      case BookingStatus.completed:
        return Icons.done_all;
    }
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
