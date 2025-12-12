import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/services/notification_service.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_state.dart';

/// Cubit for managing owner settings.
///
/// Handles:
/// - Notification preferences (email, push, booking)
/// - Auto-approve bookings setting
/// - FCM topic subscriptions for owners
class OwnerSettingsCubit extends Cubit<OwnerSettingsState> {
  OwnerSettingsCubit() : super(const OwnerSettingsState());

  /// Toggle email notifications.
  void toggleEmailNotifications(bool value) {
    emit(state.copyWith(emailNotifications: value));
  }

  /// Toggle push notifications.
  Future<void> togglePushNotifications(bool value) async {
    emit(state.copyWith(pushNotifications: value));

    // Handle FCM topic subscription
    try {
      final notificationService = NotificationService.instance;
      if (value) {
        await notificationService.subscribeToTopic('field_owners');
        debugPrint('[OwnerSettings] Subscribed to field_owners topic');
      } else {
        await notificationService.unsubscribeFromTopic('field_owners');
        debugPrint('[OwnerSettings] Unsubscribed from field_owners topic');
      }
    } catch (e) {
      debugPrint('[OwnerSettings] Error toggling push: $e');
    }
  }

  /// Toggle booking notifications.
  Future<void> toggleBookingNotifications(bool value) async {
    emit(state.copyWith(bookingNotifications: value));

    // Handle FCM topic subscription for booking alerts
    try {
      final notificationService = NotificationService.instance;
      if (value) {
        await notificationService.subscribeToTopic('booking_alerts');
        debugPrint('[OwnerSettings] Subscribed to booking_alerts topic');
      } else {
        await notificationService.unsubscribeFromTopic('booking_alerts');
        debugPrint('[OwnerSettings] Unsubscribed from booking_alerts topic');
      }
    } catch (e) {
      debugPrint('[OwnerSettings] Error toggling booking notifications: $e');
    }
  }

  /// Toggle instant notifications.
  Future<void> toggleInstantNotifications(bool value) async {
    emit(state.copyWith(instantNotifications: value));

    // Handle FCM topic subscription for instant alerts
    try {
      final notificationService = NotificationService.instance;
      if (value) {
        await notificationService.subscribeToTopic('instant_alerts');
        debugPrint('[OwnerSettings] Subscribed to instant_alerts topic');
      } else {
        await notificationService.unsubscribeFromTopic('instant_alerts');
        debugPrint('[OwnerSettings] Unsubscribed from instant_alerts topic');
      }
    } catch (e) {
      debugPrint('[OwnerSettings] Error toggling instant notifications: $e');
    }
  }

  /// Toggle auto-approve bookings.
  void toggleAutoApproveBookings(bool value) {
    emit(state.copyWith(autoApproveBookings: value));
  }
}
