import 'package:flutter/material.dart';
import 'package:spo_kick/features/recurring_bookings/domain/entities/recurring_booking_entity.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/active_subscription/recurring_active_subscription_details.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/active_subscription/recurring_active_subscription_footer.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/active_subscription/recurring_active_subscription_header.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/active_subscription/recurring_active_subscription_user_info.dart';

/// Card widget for displaying an active recurring subscription (owner view).
class ActiveSubscriptionCard extends StatelessWidget {
  final RecurringBookingEntity subscription;

  const ActiveSubscriptionCard({required this.subscription, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecurringActiveSubscriptionHeader(subscription: subscription),
          RecurringActiveSubscriptionUserInfo(subscription: subscription),
          RecurringActiveSubscriptionDetails(subscription: subscription),
          RecurringActiveSubscriptionFooter(subscription: subscription),
        ],
      ),
    );
  }
}
