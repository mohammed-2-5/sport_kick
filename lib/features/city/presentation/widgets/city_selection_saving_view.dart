import 'package:flutter/material.dart';

class CitySelectionSavingView extends StatelessWidget {
  const CitySelectionSavingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Saving your selection...'),
        ],
      ),
    );
  }
}
