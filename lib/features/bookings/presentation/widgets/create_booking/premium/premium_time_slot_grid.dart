import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/domain/entities/time_slot_entity.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/premium/time_slot_period_section.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium time slot grid with period sections and animations.
///
/// Features:
/// - Organized by period (Morning, Afternoon, Evening, Late Night)
/// - Staggered entrance animations
/// - Beautiful card design with selection state
/// - Duration-aware slot highlighting
/// - Loading shimmer state
class PremiumTimeSlotGrid extends StatelessWidget {
  final Map<String, List<TimeSlotEntity>> slotsByPeriod;
  final TimeSlotEntity? selectedSlot;
  final TimeSlotEntity? secondSlot;
  final int selectedDuration;
  final bool Function(TimeSlotEntity) canSelectSlot;
  final ValueChanged<TimeSlotEntity> onSlotSelected;
  final bool isLoading;
  final String? errorMessage;

  const PremiumTimeSlotGrid({
    super.key,
    required this.slotsByPeriod,
    required this.selectedSlot,
    required this.onSlotSelected,
    required this.canSelectSlot,
    this.secondSlot,
    this.selectedDuration = 1,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const _LoadingState();
    if (errorMessage != null) return _ErrorState(message: errorMessage!);
    if (slotsByPeriod.isEmpty) return const _EmptyState();

    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(),
          const SizedBox(height: 16),
          ...slotsByPeriod.entries.map((entry) {
            return TimeSlotPeriodSection(
              period: entry.key,
              slots: entry.value,
              selectedSlot: selectedSlot,
              secondSlot: secondSlot,
              selectedDuration: selectedDuration,
              canSelectSlot: canSelectSlot,
              onSlotSelected: onSlotSelected,
            );
          }),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        context.l10n.availableTimeSlots,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(),
          const SizedBox(height: 16),
          ...List.generate(3, (sectionIndex) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ShimmerBox(width: 100, height: 20),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(
                    4,
                    (index) => const _ShimmerBox(width: 100, height: 60),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;

  const _ShimmerBox({required this.width, required this.height});

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFE8E8E8),
                Color(0xFFF5F5F5),
                Color(0xFFE8E8E8),
              ],
              stops: [
                _animation.value - 1,
                _animation.value,
                _animation.value + 1,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_busy,
                size: 48,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.noSlotsAvailable,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.allSlotsBookedMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.somethingWentWrong,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
