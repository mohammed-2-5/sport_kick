import 'package:flutter/material.dart';

/// Loading shimmer effect for bookings list.
///
/// Displays animated shimmer placeholders while bookings are loading.
class BookingsLoadingShimmer extends StatefulWidget {
  const BookingsLoadingShimmer({super.key});

  @override
  State<BookingsLoadingShimmer> createState() => _BookingsLoadingShimmerState();
}

class _BookingsLoadingShimmerState extends State<BookingsLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    colorScheme.surfaceContainerHighest,
                    colorScheme.surface,
                    colorScheme.surfaceContainerHighest,
                  ],
                  stops: [
                    (0.3 + _animation.value / 4).clamp(0.0, 1.0),
                    (0.5 + _animation.value / 4).clamp(0.0, 1.0),
                    (0.7 + _animation.value / 4).clamp(0.0, 1.0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
