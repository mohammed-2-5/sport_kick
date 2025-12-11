import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/bookings/domain/entities/booking_entity.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/activate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/deactivate_user_usecase.dart';
import 'package:spo_kick/features/super_admin/domain/usecases/get_all_bookings_usecase.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/user_details/user_details_state.dart';

/// Cubit for managing user details screen state.
///
/// Handles:
/// - Loading user bookings
/// - Computing statistics
/// - Status toggle operations
/// - Dialog state management
class UserDetailsCubit extends Cubit<UserDetailsState> {
  final GetAllBookingsUseCase _getAllBookingsUseCase;
  final ActivateUserUseCase _activateUserUseCase;
  final DeactivateUserUseCase _deactivateUserUseCase;

  UserDetailsCubit({
    required GetAllBookingsUseCase getAllBookingsUseCase,
    required ActivateUserUseCase activateUserUseCase,
    required DeactivateUserUseCase deactivateUserUseCase,
  }) : _getAllBookingsUseCase = getAllBookingsUseCase,
       _activateUserUseCase = activateUserUseCase,
       _deactivateUserUseCase = deactivateUserUseCase,
       super(const UserDetailsLoading());

  /// Initialize with user data and load bookings.
  Future<void> initialize(UserEntity user) async {
    emit(const UserDetailsLoading());

    final result = await _getAllBookingsUseCase();

    result.fold(
      (failure) => emit(UserDetailsError(message: failure.message, user: user)),
      (allBookings) {
        final userBookings =
            allBookings.where((b) => b.userId == user.id).toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        final stats = UserDetailsStats.fromBookings(
          userBookings,
          user.createdAt,
        );

        emit(
          UserDetailsLoaded(user: user, bookings: userBookings, stats: stats),
        );
      },
    );
  }

  /// Show status toggle confirmation dialog.
  void showStatusToggleDialog() {
    final currentState = state;
    if (currentState is UserDetailsLoaded) {
      emit(currentState.copyWith(showStatusDialog: true));
    }
  }

  /// Hide status toggle confirmation dialog.
  void hideStatusToggleDialog() {
    final currentState = state;
    if (currentState is UserDetailsLoaded) {
      emit(currentState.copyWith(showStatusDialog: false));
    }
  }

  /// Toggle user active status.
  Future<void> toggleUserStatus() async {
    final currentState = state;
    if (currentState is! UserDetailsLoaded) return;

    emit(
      currentState.copyWith(isTogglingStatus: true, showStatusDialog: false),
    );

    final user = currentState.user;
    final result = user.isActive
        ? await _deactivateUserUseCase(userId: user.id)
        : await _activateUserUseCase(userId: user.id);

    result.fold(
      (failure) => emit(UserDetailsError(message: failure.message, user: user)),
      (_) {
        final updatedUser = user.copyWith(isActive: !user.isActive);
        emit(
          UserStatusToggled(user: updatedUser, wasActivated: !user.isActive),
        );
      },
    );
  }

  /// Restore to loaded state after status toggle.
  void restoreAfterToggle(
    UserEntity updatedUser,
    List<BookingEntity> bookings,
  ) {
    final stats = UserDetailsStats.fromBookings(
      bookings,
      updatedUser.createdAt,
    );

    emit(
      UserDetailsLoaded(user: updatedUser, bookings: bookings, stats: stats),
    );
  }

  /// Get formatted member since date.
  String getMemberSinceFormatted(DateTime createdAt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[createdAt.month - 1]} ${createdAt.day}, ${createdAt.year}';
  }

  /// Get booking status color index for UI.
  int getStatusColorIndex(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 0; // Green
      case 'confirmed':
        return 1; // Blue
      case 'pending':
        return 2; // Orange
      case 'cancelled':
        return 3; // Red
      default:
        return 4; // Grey
    }
  }
}
