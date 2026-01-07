import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/owner/domain/usecases/update_owner_profile_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_profile/owner_profile_update_state.dart';

/// Cubit for managing owner profile update operations.
///
/// Handles profile information updates for field owners.
class OwnerProfileUpdateCubit extends Cubit<OwnerProfileUpdateState> {
  final UpdateOwnerProfileUseCase updateOwnerProfileUseCase;

  OwnerProfileUpdateCubit({required this.updateOwnerProfileUseCase})
    : super(const OwnerProfileUpdateInitial());

  /// Update owner profile information
  Future<void> updateProfile({
    required String ownerId,
    String? fullName,
    String? phone,
  }) async {
    debugPrint(
      '🔄 [OwnerProfileUpdateCubit] Updating profile for owner: $ownerId',
    );
    emit(const OwnerProfileUpdateLoading(message: 'Updating profile...'));

    final result = await updateOwnerProfileUseCase(
      ownerId: ownerId,
      fullName: fullName,
      phone: phone,
    );

    result.fold(
      (failure) {
        debugPrint(
          '❌ [OwnerProfileUpdateCubit] Error updating profile: ${failure.message}',
        );
        emit(OwnerProfileUpdateError(failure.message));
      },
      (_) {
        debugPrint('✅ [OwnerProfileUpdateCubit] Profile updated successfully');
        emit(const ProfileUpdated('Profile updated successfully'));
      },
    );
  }

  /// Reset to initial state.
  void reset() {
    debugPrint('🔄 [OwnerProfileUpdateCubit] Resetting state');
    emit(const OwnerProfileUpdateInitial());
  }
}
