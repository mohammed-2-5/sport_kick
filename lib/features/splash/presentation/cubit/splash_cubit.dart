import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spo_kick/features/city/domain/usecases/get_selected_city_usecase.dart';
import 'package:spo_kick/features/onboarding/domain/usecases/check_onboarding_status_usecase.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CheckOnboardingStatusUseCase checkOnboardingStatusUseCase;
  final GetSelectedCityUseCase getSelectedCityUseCase;

  SplashCubit({
    required this.getCurrentUserUseCase,
    required this.checkOnboardingStatusUseCase,
    required this.getSelectedCityUseCase,
  }) : super(const SplashInitial());

  Future<void> initializeApp() async {
    if (!isClosed) emit(const SplashLoading());

    // Artificial delay for animations (optional, but requested in previous SplashPage logic)
    await Future.delayed(const Duration(milliseconds: 2500));

    if (isClosed) return; // Exit if cubit is closed after delay

    // 1. Check Onboarding
    final isOnboardingCompleted = await checkOnboardingStatusUseCase();
    if (isClosed) return;

    if (!isOnboardingCompleted) {
      emit(const SplashNavigateToOnboarding());
      return;
    }

    // 2. Check Auth
    final userResult = await getCurrentUserUseCase();
    if (isClosed) return;

    userResult.fold(
      (failure) {
        if (!isClosed) emit(const SplashNavigateToLogin());
      },
      (user) async {
        if (user != null) {
          // 3. User is logged in. Check Role.
          if (user.role == 'super_admin' || user.role == 'admin') {
            if (!isClosed) emit(SplashNavigateToHome(user.role));
          } else {
            // Regular User: Check City
            final cityResult = await getSelectedCityUseCase();

            if (isClosed) return;

            cityResult.fold(
              (failure) {
                if (!isClosed) emit(const SplashNavigateToCitySelection());
              },
              (cityId) {
                if (isClosed) return;
                if (cityId == null || cityId.isEmpty) {
                  emit(const SplashNavigateToCitySelection());
                } else {
                  emit(SplashNavigateToHome(user.role));
                }
              },
            );
          }
        } else {
          if (!isClosed) emit(const SplashNavigateToLogin());
        }
      },
    );
  }
}
