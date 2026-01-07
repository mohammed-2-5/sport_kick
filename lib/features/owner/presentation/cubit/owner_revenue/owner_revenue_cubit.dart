import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/owner/domain/usecases/get_owner_revenue_usecase.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_revenue/owner_revenue_state.dart';

/// Cubit for managing owner revenue operations.
///
/// Handles revenue statistics loading for field owners.
class OwnerRevenueCubit extends Cubit<OwnerRevenueState> {
  final GetOwnerRevenueUseCase getOwnerRevenueUseCase;

  OwnerRevenueCubit({required this.getOwnerRevenueUseCase})
    : super(const OwnerRevenueInitial());

  /// Load revenue statistics for owner
  Future<void> loadOwnerRevenue(String ownerId) async {
    debugPrint('🔄 [OwnerRevenueCubit] Loading revenue for owner: $ownerId');
    emit(const OwnerRevenueLoading(message: 'Loading revenue data...'));

    final result = await getOwnerRevenueUseCase(ownerId: ownerId);

    result.fold(
      (failure) {
        debugPrint(
          '❌ [OwnerRevenueCubit] Error loading revenue: ${failure.message}',
        );
        emit(OwnerRevenueError(failure.message));
      },
      (revenue) {
        debugPrint('✅ [OwnerRevenueCubit] Revenue loaded successfully');
        emit(OwnerRevenueLoaded(revenue));
      },
    );
  }

  /// Reset to initial state.
  void reset() {
    debugPrint('🔄 [OwnerRevenueCubit] Resetting state');
    emit(const OwnerRevenueInitial());
  }
}
