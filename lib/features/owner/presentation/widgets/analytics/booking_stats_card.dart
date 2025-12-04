import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';

/// Card displaying booking statistics (Pending, Confirmed, Completed).
class BookingStatsCard extends StatelessWidget {
  const BookingStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking Statistics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        BlocBuilder<OwnerCubit, OwnerState>(
          builder: (context, state) {
            int pending = 0;
            int confirmed = 0;
            int completed = 0;

            if (state is OwnerDataLoaded || state is OwnerBookingsLoaded) {
              final bookings = state is OwnerDataLoaded
                  ? state.bookings
                  : (state as OwnerBookingsLoaded).bookings;

              pending = bookings
                  .where((b) => b.status.toString().contains('pending'))
                  .length;
              confirmed = bookings
                  .where((b) => b.status.toString().contains('confirmed'))
                  .length;
              completed = bookings
                  .where((b) => b.status.toString().contains('completed'))
                  .length;
            }

            return Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    pending.toString(),
                    Icons.pending_actions_rounded,
                    const LinearGradient(
                      colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Confirmed',
                    confirmed.toString(),
                    Icons.check_circle_rounded,
                    const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Completed',
                    completed.toString(),
                    Icons.done_all_rounded,
                    const LinearGradient(
                      colors: [Color(0xFF42A5F5), Color(0xFF64B5F6)],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    LinearGradient gradient,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
