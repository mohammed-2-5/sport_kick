import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/bookings/presentation/constants/booking_constants.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/duration_option_card.dart';
import 'package:spo_kick/features/bookings/presentation/widgets/create_booking/duration_selector_header.dart';

/// Premium booking duration selector widget.
///
/// Allows users to select between 1-hour and 2-hour bookings
/// with visual price indication and availability state.
class BookingDurationSelector extends StatelessWidget {
  /// Currently selected duration (1 or 2 hours).
  final int selectedDuration;

  /// Price per hour for the field.
  final double pricePerHour;

  /// Callback when duration is selected.
  final ValueChanged<int> onDurationSelected;

  /// Whether 2-hour option is available (consecutive slot exists).
  final bool isTwoHourAvailable;

  const BookingDurationSelector({
    super.key,
    required this.selectedDuration,
    required this.pricePerHour,
    required this.onDurationSelected,
    this.isTwoHourAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 400;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DurationSelectorHeader(),
        const SizedBox(height: BookingConstants.itemSpacing),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BookingConstants.standardPadding,
          ),
          child: isCompact
              ? _DurationOptionsColumn(
                  selectedDuration: selectedDuration,
                  pricePerHour: pricePerHour,
                  isTwoHourAvailable: isTwoHourAvailable,
                  onDurationSelected: onDurationSelected,
                  recommendedLabel: l10n.durationRecommended,
                  bestValueLabel: l10n.durationBestValue,
                  unavailableMessage: l10n.durationUnavailable,
                )
              : _DurationOptionsRow(
                  selectedDuration: selectedDuration,
                  pricePerHour: pricePerHour,
                  isTwoHourAvailable: isTwoHourAvailable,
                  onDurationSelected: onDurationSelected,
                  recommendedLabel: l10n.durationRecommended,
                  bestValueLabel: l10n.durationBestValue,
                  unavailableMessage: l10n.durationUnavailable,
                ),
        ),
      ],
    );
  }
}

class _DurationOptionsRow extends StatelessWidget {
  final int selectedDuration;
  final double pricePerHour;
  final bool isTwoHourAvailable;
  final ValueChanged<int> onDurationSelected;
  final String recommendedLabel;
  final String bestValueLabel;
  final String unavailableMessage;

  const _DurationOptionsRow({
    required this.selectedDuration,
    required this.pricePerHour,
    required this.isTwoHourAvailable,
    required this.onDurationSelected,
    required this.recommendedLabel,
    required this.bestValueLabel,
    required this.unavailableMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DurationOptionCard(
            duration: 1,
            pricePerHour: pricePerHour,
            isSelected: selectedDuration == 1,
            isAvailable: true,
            onTap: () => onDurationSelected(1),
            badgeText: recommendedLabel,
          ),
        ),
        const SizedBox(width: BookingConstants.itemSpacing),
        Expanded(
          child: DurationOptionCard(
            duration: 2,
            pricePerHour: pricePerHour,
            isSelected: selectedDuration == 2,
            isAvailable: isTwoHourAvailable,
            onTap: isTwoHourAvailable ? () => onDurationSelected(2) : null,
            badgeText: isTwoHourAvailable ? bestValueLabel : null,
            unavailableMessage: unavailableMessage,
          ),
        ),
      ],
    );
  }
}

class _DurationOptionsColumn extends StatelessWidget {
  final int selectedDuration;
  final double pricePerHour;
  final bool isTwoHourAvailable;
  final ValueChanged<int> onDurationSelected;
  final String recommendedLabel;
  final String bestValueLabel;
  final String unavailableMessage;

  const _DurationOptionsColumn({
    required this.selectedDuration,
    required this.pricePerHour,
    required this.isTwoHourAvailable,
    required this.onDurationSelected,
    required this.recommendedLabel,
    required this.bestValueLabel,
    required this.unavailableMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DurationOptionCard(
          duration: 1,
          pricePerHour: pricePerHour,
          isSelected: selectedDuration == 1,
          isAvailable: true,
          onTap: () => onDurationSelected(1),
          badgeText: recommendedLabel,
        ),
        const SizedBox(height: BookingConstants.smallPadding),
        DurationOptionCard(
          duration: 2,
          pricePerHour: pricePerHour,
          isSelected: selectedDuration == 2,
          isAvailable: isTwoHourAvailable,
          onTap: isTwoHourAvailable ? () => onDurationSelected(2) : null,
          badgeText: isTwoHourAvailable ? bestValueLabel : null,
          unavailableMessage: unavailableMessage,
        ),
      ],
    );
  }
}
