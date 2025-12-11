import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/fields/presentation/cubit/field_details_scroll_state.dart';

/// Cubit for managing field details scroll behavior.
///
/// Handles:
/// - Scroll offset tracking
/// - Floating header visibility
/// - Header opacity transitions
class FieldDetailsScrollCubit extends Cubit<FieldDetailsScrollState> {
  FieldDetailsScrollCubit() : super(const FieldDetailsScrollInitial());

  // Threshold for showing floating header
  static const double _showHeaderThreshold = 200.0;
  static const double _fadeStartThreshold = 150.0;
  static const double _fadeEndThreshold = 220.0;

  /// Update scroll position and calculate header state.
  void updateScroll(double offset) {
    final showHeader = offset > _showHeaderThreshold;

    // Calculate opacity: 0 at fadeStart, 1 at fadeEnd
    double opacity = 0.0;
    if (offset > _fadeStartThreshold) {
      opacity =
          ((offset - _fadeStartThreshold) /
                  (_fadeEndThreshold - _fadeStartThreshold))
              .clamp(0.0, 1.0);
    }

    emit(
      FieldDetailsScrollActive(
        scrollOffset: offset,
        showFloatingHeader: showHeader,
        headerOpacity: opacity,
      ),
    );
  }

  /// Reset scroll state.
  void reset() {
    emit(const FieldDetailsScrollInitial());
  }
}
