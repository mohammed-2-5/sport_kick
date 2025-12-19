import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/features/city/presentation/constants/city_constants.dart';

class CitySelectionContinueButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onContinue;

  const CitySelectionContinueButton({
    super.key,
    required this.isEnabled,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CityConstants.screenPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isEnabled ? onContinue : null,
            child: Text(context.l10n.continueLabel),
          ),
        ),
      ),
    );
  }
}
