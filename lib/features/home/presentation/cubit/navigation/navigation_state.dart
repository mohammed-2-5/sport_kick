import 'package:equatable/equatable.dart';

/// State for main navigation.
///
/// Manages:
/// - Current tab index
/// - Tab change animations
/// - FAB visibility
sealed class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object?> get props => [];
}

/// Navigation state with current tab.
final class NavigationActive extends NavigationState {
  final int currentIndex;
  final int previousIndex;
  final bool isAnimating;
  final bool showFab;

  const NavigationActive({
    this.currentIndex = 0,
    this.previousIndex = 0,
    this.isAnimating = false,
    this.showFab = true,
  });

  NavigationActive copyWith({
    int? currentIndex,
    int? previousIndex,
    bool? isAnimating,
    bool? showFab,
  }) {
    return NavigationActive(
      currentIndex: currentIndex ?? this.currentIndex,
      previousIndex: previousIndex ?? this.previousIndex,
      isAnimating: isAnimating ?? this.isAnimating,
      showFab: showFab ?? this.showFab,
    );
  }

  @override
  List<Object?> get props => [
    currentIndex,
    previousIndex,
    isAnimating,
    showFab,
  ];
}

/// Navigation tab definition.
class NavigationTab {
  final int index;
  final String label;
  final String activeIcon;
  final String inactiveIcon;

  const NavigationTab({
    required this.index,
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
  });
}
