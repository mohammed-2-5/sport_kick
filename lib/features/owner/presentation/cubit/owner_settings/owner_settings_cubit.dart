import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_settings/owner_settings_state.dart';

/// Cubit for managing owner settings.
///
/// Handles:
/// - Notification preferences (email, push, booking)
/// - Auto-approve bookings setting
class OwnerSettingsCubit extends Cubit<OwnerSettingsState> {
  OwnerSettingsCubit() : super(const OwnerSettingsState());

  /// Toggle email notifications.
  void toggleEmailNotifications(bool value) {
    emit(state.copyWith(emailNotifications: value));
  }

  /// Toggle push notifications.
  void togglePushNotifications(bool value) {
    emit(state.copyWith(pushNotifications: value));
  }

  /// Toggle booking notifications.
  void toggleBookingNotifications(bool value) {
    emit(state.copyWith(bookingNotifications: value));
  }

  /// Toggle auto-approve bookings.
  void toggleAutoApproveBookings(bool value) {
    emit(state.copyWith(autoApproveBookings: value));
  }
}
