import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/home/presentation/cubit/navigation/navigation_state.dart';

/// Cubit for managing main navigation state.
///
/// Handles:
/// - Tab switching with animation tracking
/// - FAB visibility control
/// - Navigation history
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationActive());

  /// Change to a specific tab.
  void changeTab(int index) {
    final currentState = state;
    if (currentState is NavigationActive) {
      if (currentState.currentIndex == index) return;

      emit(
        currentState.copyWith(
          currentIndex: index,
          previousIndex: currentState.currentIndex,
          isAnimating: true,
        ),
      );

      // Reset animation flag after animation completes
      Future.delayed(const Duration(milliseconds: 300), () {
        final newState = state;
        if (newState is NavigationActive) {
          emit(newState.copyWith(isAnimating: false));
        }
      });
    }
  }

  /// Go to home tab.
  void goToHome() => changeTab(0);

  /// Go to explore tab.
  void goToExplore() => changeTab(1);

  /// Go to bookings tab.
  void goToBookings() => changeTab(2);

  /// Go to profile tab.
  void goToProfile() => changeTab(3);

  /// Show or hide FAB.
  void setFabVisibility(bool visible) {
    final currentState = state;
    if (currentState is NavigationActive) {
      emit(currentState.copyWith(showFab: visible));
    }
  }

  /// Toggle FAB visibility.
  void toggleFab() {
    final currentState = state;
    if (currentState is NavigationActive) {
      emit(currentState.copyWith(showFab: !currentState.showFab));
    }
  }

  /// Get current tab index.
  int get currentIndex {
    final currentState = state;
    if (currentState is NavigationActive) {
      return currentState.currentIndex;
    }
    return 0;
  }

  /// Check if navigating forward (left to right).
  bool get isNavigatingForward {
    final currentState = state;
    if (currentState is NavigationActive) {
      return currentState.currentIndex > currentState.previousIndex;
    }
    return true;
  }
}
