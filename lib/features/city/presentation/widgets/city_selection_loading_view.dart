import 'package:flutter/material.dart';
import 'package:spo_kick/features/city/presentation/constants/city_constants.dart';

class CitySelectionLoadingView extends StatelessWidget {
  const CitySelectionLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(CityConstants.loadingCities),
        ],
      ),
    );
  }
}
