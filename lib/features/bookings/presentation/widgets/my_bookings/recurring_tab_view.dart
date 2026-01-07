import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_cubit.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/my_recurring_bookings_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/recurring/recurring_content_list.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/recurring/recurring_empty_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/recurring/recurring_error_state.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/my_bookings/recurring/recurring_loading_state.dart';

/// Tab view for recurring bookings in My Bookings page.
///
/// Follows clean architecture by:
/// - Using BlocBuilder for state management
/// - Separating UI concerns into dedicated widgets
/// - Reusing existing RecurringBookingCard component
/// - No business logic in UI layer (data loading handled by cubit/router)
class RecurringTabView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final VoidCallback onCreateNew;

  const RecurringTabView({
    required this.onRefresh,
    required this.onCreateNew,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyRecurringBookingsCubit, MyRecurringBookingsState>(
      builder: (context, state) {
        return switch (state) {
          MyRecurringBookingsInitial() => const RecurringLoadingState(),
          MyRecurringBookingsLoading() => const RecurringLoadingState(),
          MyRecurringBookingsError(:final message) => RecurringErrorState(
            message: message,
          ),
          MyRecurringBookingsLoaded(:final bookings) =>
            bookings.isEmpty
                ? RecurringEmptyState(onCreateNew: onCreateNew)
                : RecurringContentList(state: state, onRefresh: onRefresh),
          MyRecurringBookingsActionInProgress(:final bookings) =>
            RecurringContentList(
              state: MyRecurringBookingsLoaded(bookings: bookings),
              onRefresh: onRefresh,
            ),
        };
      },
    );
  }
}
