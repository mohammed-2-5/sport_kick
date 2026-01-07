import 'package:equatable/equatable.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/admin_invitation_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_statistics_entity.dart';

/// Base state for super admin features.
sealed class SuperAdminState extends Equatable {
  const SuperAdminState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class SuperAdminInitial extends SuperAdminState {
  const SuperAdminInitial();
}

/// Loading state with optional message.
class SuperAdminLoading extends SuperAdminState {
  final String message;

  const SuperAdminLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Error state with error message.
class SuperAdminError extends SuperAdminState {
  final String message;

  const SuperAdminError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Platform statistics loaded successfully.
class PlatformStatisticsLoaded extends SuperAdminState {
  final PlatformStatisticsEntity statistics;

  const PlatformStatisticsLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

/// Admin account created successfully.
class AdminAccountCreated extends SuperAdminState {
  final AdminInvitationEntity invitation;

  const AdminAccountCreated(this.invitation);

  @override
  List<Object?> get props => [invitation];

  /// Get display message for success notification
  String get successMessage =>
      'Admin created successfully!\n\nEmail: ${invitation.email}\nPassword: ${invitation.defaultPassword}\n\nPlease save these credentials!';
}

/// List of admins loaded.
class AdminsListLoaded extends SuperAdminState {
  final List<UserEntity> admins;

  const AdminsListLoaded(this.admins);

  @override
  List<Object?> get props => [admins];
}

/// List of users loaded.
class UsersListLoaded extends SuperAdminState {
  final List<UserEntity> users;

  const UsersListLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

/// Field assigned to admin successfully.
class FieldAssigned extends SuperAdminState {
  final String adminId;
  final String fieldId;

  const FieldAssigned({required this.adminId, required this.fieldId});

  @override
  List<Object?> get props => [adminId, fieldId];
}

/// List of cities loaded.
class CitiesLoaded extends SuperAdminState {
  final List<CityEntity> cities;

  const CitiesLoaded(this.cities);

  @override
  List<Object?> get props => [cities];
}

/// City created successfully.
class CityCreated extends SuperAdminState {
  final CityEntity city;

  const CityCreated(this.city);

  @override
  List<Object?> get props => [city];

  String get successMessage => 'City "${city.name}" created successfully!';
}

/// City updated successfully.
class CityUpdated extends SuperAdminState {
  final CityEntity city;

  const CityUpdated(this.city);

  @override
  List<Object?> get props => [city];

  String get successMessage => 'City "${city.name}" updated successfully!';
}

/// City deleted successfully.
class CityDeleted extends SuperAdminState {
  final String cityId;
  final bool wasHardDelete;

  const CityDeleted({required this.cityId, required this.wasHardDelete});

  @override
  List<Object?> get props => [cityId, wasHardDelete];

  String get successMessage => wasHardDelete
      ? 'City permanently deleted'
      : 'City deactivated successfully';
}

/// User deactivated successfully.
class UserDeactivated extends SuperAdminState {
  final String userId;

  const UserDeactivated(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// User activated successfully.
class UserActivated extends SuperAdminState {
  final String userId;

  const UserActivated(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// All fields loaded successfully.
class AllFieldsLoaded extends SuperAdminState {
  final List<FieldEntity> fields;

  const AllFieldsLoaded(this.fields);

  @override
  List<Object?> get props => [fields];
}

/// All bookings loaded successfully.
class AllBookingsLoaded extends SuperAdminState {
  final List<BookingEntity> bookings;

  const AllBookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

/// Field created successfully.
class FieldCreated extends SuperAdminState {
  final FieldEntity field;

  const FieldCreated(this.field);

  @override
  List<Object?> get props => [field];

  /// Get display message for success notification
  String get successMessage =>
      'Field created successfully!\n\nName: ${field.name}\nCity: ${field.city}\nPrice: ${field.formattedPrice}';
}

/// Bulk action completed successfully.
class BulkActionCompleted extends SuperAdminState {
  final String message;

  const BulkActionCompleted(this.message);

  @override
  List<Object?> get props => [message];
}

/// Combined analytics data loaded successfully.
class AnalyticsDataLoaded extends SuperAdminState {
  final List<BookingEntity> bookings;
  final List<FieldEntity> fields;
  final PlatformStatisticsEntity? statistics;

  const AnalyticsDataLoaded({
    required this.bookings,
    required this.fields,
    this.statistics,
  });

  @override
  List<Object?> get props => [bookings, fields, statistics];
}

/// Field updated successfully.
class FieldUpdated extends SuperAdminState {
  final FieldEntity field;

  const FieldUpdated(this.field);

  @override
  List<Object?> get props => [field];

  String get successMessage => 'Field "${field.name}" updated successfully!';
}

/// Field deleted successfully.
class FieldDeleted extends SuperAdminState {
  final String fieldId;
  final bool wasHardDelete;

  const FieldDeleted({required this.fieldId, required this.wasHardDelete});

  @override
  List<Object?> get props => [fieldId, wasHardDelete];

  String get successMessage => wasHardDelete
      ? 'Field permanently deleted'
      : 'Field deactivated successfully';
}

/// Field verification status changed.
class FieldVerified extends SuperAdminState {
  final String fieldId;
  final bool isVerified;

  const FieldVerified({required this.fieldId, required this.isVerified});

  @override
  List<Object?> get props => [fieldId, isVerified];

  String get successMessage =>
      isVerified ? 'Field verified successfully' : 'Field verification removed';
}

/// Booking status updated successfully.
class BookingStatusUpdated extends SuperAdminState {
  final String bookingId;
  final String newStatus;

  const BookingStatusUpdated({
    required this.bookingId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [bookingId, newStatus];

  String get successMessage => 'Booking status updated to $newStatus';
}

/// Booking cancelled successfully.
class BookingCancelled extends SuperAdminState {
  final String bookingId;

  const BookingCancelled({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];

  String get successMessage => 'Booking cancelled successfully';
}
