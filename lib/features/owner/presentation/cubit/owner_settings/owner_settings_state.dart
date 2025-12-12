import 'package:equatable/equatable.dart';

/// State for owner settings.
final class OwnerSettingsState extends Equatable {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool bookingNotifications;
  final bool instantNotifications;
  final bool autoApproveBookings;

  const OwnerSettingsState({
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.bookingNotifications = true,
    this.instantNotifications = true,
    this.autoApproveBookings = false,
  });

  @override
  List<Object?> get props => [
    emailNotifications,
    pushNotifications,
    bookingNotifications,
    instantNotifications,
    autoApproveBookings,
  ];

  OwnerSettingsState copyWith({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? bookingNotifications,
    bool? instantNotifications,
    bool? autoApproveBookings,
  }) {
    return OwnerSettingsState(
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      bookingNotifications: bookingNotifications ?? this.bookingNotifications,
      instantNotifications: instantNotifications ?? this.instantNotifications,
      autoApproveBookings: autoApproveBookings ?? this.autoApproveBookings,
    );
  }
}
