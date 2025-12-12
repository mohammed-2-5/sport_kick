import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_login_activity_usecase.dart';
import 'package:spo_kick/features/auth/presentation/cubit/login_activity_state.dart';

/// Login Activity Cubit
///
/// Manages login activity state for the UI.
class LoginActivityCubit extends Cubit<LoginActivityState> {
  final GetLoginActivityUseCase _getLoginActivity;
  final GetAllLoginActivityUseCase _getAllLoginActivity;

  static const int _pageSize = 20;
  int _currentOffset = 0;
  String? _currentUserId;
  bool _isSuperAdmin = false;

  LoginActivityCubit({
    required GetLoginActivityUseCase getLoginActivity,
    required GetAllLoginActivityUseCase getAllLoginActivity,
  }) : _getLoginActivity = getLoginActivity,
       _getAllLoginActivity = getAllLoginActivity,
       super(const LoginActivityInitial());

  /// Load login activity for a specific user.
  Future<void> loadLoginActivity(String userId) async {
    _currentUserId = userId;
    _currentOffset = 0;
    _isSuperAdmin = false;
    emit(const LoginActivityLoading());

    final result = await _getLoginActivity(userId, limit: _pageSize, offset: 0);

    result.fold(
      (failure) => emit(LoginActivityError(failure.message)),
      (activities) => emit(
        LoginActivityLoaded(
          activities: activities,
          hasMore: activities.length >= _pageSize,
        ),
      ),
    );
  }

  /// Load all login activity (for super admin).
  Future<void> loadAllLoginActivity({String? statusFilter}) async {
    _currentOffset = 0;
    _isSuperAdmin = true;
    emit(const LoginActivityLoading());

    final result = await _getAllLoginActivity(
      limit: _pageSize,
      offset: 0,
      statusFilter: statusFilter,
    );

    result.fold(
      (failure) => emit(LoginActivityError(failure.message)),
      (activities) => emit(
        LoginActivityLoaded(
          activities: activities,
          hasMore: activities.length >= _pageSize,
        ),
      ),
    );
  }

  /// Load more login activity (pagination).
  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! LoginActivityLoaded ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));
    _currentOffset += _pageSize;

    final result = _isSuperAdmin
        ? await _getAllLoginActivity(limit: _pageSize, offset: _currentOffset)
        : await _getLoginActivity(
            _currentUserId!,
            limit: _pageSize,
            offset: _currentOffset,
          );

    result.fold(
      (failure) {
        _currentOffset -= _pageSize;
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (newActivities) => emit(
        LoginActivityLoaded(
          activities: [...currentState.activities, ...newActivities],
          hasMore: newActivities.length >= _pageSize,
          isLoadingMore: false,
        ),
      ),
    );
  }

  /// Refresh login activity.
  Future<void> refresh() async {
    if (_isSuperAdmin) {
      await loadAllLoginActivity();
    } else if (_currentUserId != null) {
      await loadLoginActivity(_currentUserId!);
    }
  }
}
