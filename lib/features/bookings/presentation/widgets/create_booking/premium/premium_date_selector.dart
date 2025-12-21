import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:spo_kick/core/constants/app_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';

/// Premium horizontal date selector with scrollable date cards.
///
/// Features:
/// - Horizontal scrollable date list (14 days)
/// - Today highlighting
/// - Selected state with glow effect
/// - Smooth scroll animation to selected date
class PremiumDateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const PremiumDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<PremiumDateSelector> createState() => _PremiumDateSelectorState();
}

class _PremiumDateSelectorState extends State<PremiumDateSelector> {
  late ScrollController _scrollController;
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  void _generateDates() {
    final today = DateTime.now();
    _dates = List.generate(
      BookingConstants.bookingAdvanceDays,
      (index) => DateTime(today.year, today.month, today.day + index),
    );
  }

  void _scrollToSelectedDate() {
    final selectedIndex = _dates.indexWhere(
      (date) =>
          date.year == widget.selectedDate.year &&
          date.month == widget.selectedDate.month &&
          date.day == widget.selectedDate.day,
    );

    if (selectedIndex != -1 && _scrollController.hasClients) {
      final offset = (selectedIndex * 76.0) - 100; // Center the selected date
      _scrollController.animateTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: AppAnimations.normal,
        curve: AppAnimations.easeInOut,
      );
    }
  }

  @override
  void didUpdateWidget(PremiumDateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _scrollToSelectedDate();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.selectDate,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                DateFormat('MMMM yyyy', locale).format(widget.selectedDate),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.accentCyan,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _dates.length,
            itemBuilder: (context, index) {
              final date = _dates[index];
              final isSelected = _isSameDay(date, widget.selectedDate);
              final isToday = _isSameDay(date, DateTime.now());

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _DateCard(
                  date: date,
                  isSelected: isSelected,
                  isToday: isToday,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    widget.onDateSelected(date);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// Individual date card widget.
class _DateCard extends StatefulWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _DateCard({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  State<_DateCard> createState() => _DateCardState();
}

class _DateCardState extends State<_DateCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppAnimations.buttonPressScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          width: 68,
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  )
                : null,
            color: widget.isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: widget.isSelected
                ? null
                : Border.all(
                    color: widget.isToday
                        ? AppColors.accentCyan.withValues(alpha: 0.5)
                        : AppColors.border,
                    width: widget.isToday ? 2 : 1,
                  ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('EEE', locale).format(widget.date).toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected
                      ? Colors.white.withValues(alpha: 0.9)
                      : AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.date.day}',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: widget.isSelected
                      ? Colors.white
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              if (widget.isToday && !widget.isSelected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentCyan,
                  ),
                )
              else
                const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
