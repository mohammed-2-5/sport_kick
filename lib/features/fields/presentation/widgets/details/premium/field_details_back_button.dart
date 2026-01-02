import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/fields/presentation/cubit/field_details_scroll_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/field_details_scroll_state.dart';

/// Back button that fades out when floating header appears.
///
/// Positioned at top-left, animated based on scroll position.
class FieldDetailsBackButton extends StatelessWidget {
  const FieldDetailsBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FieldDetailsScrollCubit, FieldDetailsScrollState>(
      builder: (context, scrollState) {
        final opacity = _calculateOpacity(scrollState);

        return Positioned(
          top: 50,
          left: 16,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateOpacity(FieldDetailsScrollState state) {
    if (state is FieldDetailsScrollActive) {
      return 1.0 - state.headerOpacity;
    }
    return 1.0;
  }
}
