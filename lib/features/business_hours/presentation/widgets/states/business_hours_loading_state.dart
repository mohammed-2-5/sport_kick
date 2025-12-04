import 'package:flutter/material.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_constants.dart';
import 'package:spo_kick/features/business_hours/presentation/constants/business_hours_strings.dart';

/// Loading state widget for business hours feature.
///
/// Displays a centered loading indicator with a message while
/// business hours data is being fetched.
class BusinessHoursLoadingState extends StatelessWidget {
  const BusinessHoursLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: BusinessHoursConstants.itemSpacing),
          Text(BusinessHoursStrings.loadingMessage),
        ],
      ),
    );
  }
}
