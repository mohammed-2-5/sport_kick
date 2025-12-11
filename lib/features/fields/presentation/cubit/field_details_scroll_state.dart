import 'package:equatable/equatable.dart';

/// State for field details scroll behavior.
///
/// Manages:
/// - Floating header visibility
/// - Parallax scroll offset
/// - Image gallery state
sealed class FieldDetailsScrollState extends Equatable {
  const FieldDetailsScrollState();

  @override
  List<Object?> get props => [];
}

/// Initial state - header hidden, no scroll.
class FieldDetailsScrollInitial extends FieldDetailsScrollState {
  const FieldDetailsScrollInitial();
}

/// Active scrolling state.
class FieldDetailsScrollActive extends FieldDetailsScrollState {
  final double scrollOffset;
  final bool showFloatingHeader;
  final double headerOpacity;

  const FieldDetailsScrollActive({
    required this.scrollOffset,
    required this.showFloatingHeader,
    required this.headerOpacity,
  });

  @override
  List<Object?> get props => [scrollOffset, showFloatingHeader, headerOpacity];
}
