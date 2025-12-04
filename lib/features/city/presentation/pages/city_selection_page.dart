import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/constants/city_constants.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_cubit.dart';
import 'package:spo_kick/features/city/presentation/cubit/city_state.dart';
import 'package:spo_kick/features/city/presentation/widgets/city_card.dart';

/// City Selection Page
///
/// Displays available cities for user selection on first launch.
/// Shows cities in a responsive grid layout.
class CitySelectionPage extends StatefulWidget {
  const CitySelectionPage({super.key});

  @override
  State<CitySelectionPage> createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  CityEntity? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  void _loadCities() {
    context.read<CityCubit>().loadCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(CityConstants.citySelectionTitle),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<CityCubit, CityState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state is CitiesLoading) {
            return _buildLoadingView();
          }

          if (state is CityError) {
            return _buildErrorView(state.message);
          }

          if (state is CitiesLoaded) {
            return _buildCityGrid(context, state.cities);
          }

          if (state is CitySaving) {
            return _buildSavingView();
          }

          return _buildEmptyView();
        },
      ),
      bottomNavigationBar: _buildContinueButton(context),
    );
  }

  Widget _buildLoadingView() {
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

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(CityConstants.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              CityConstants.errorLoadingCities,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _loadCities,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(CityConstants.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off,
              size: 64,
              color: AppColors.mediumGrey,
            ),
            const SizedBox(height: 16),
            Text(
              CityConstants.noCitiesAvailable,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Please contact support for assistance',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingView() {
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

  Widget _buildCityGrid(BuildContext context, List<CityEntity> cities) {
    if (cities.isEmpty) {
      return _buildEmptyView();
    }

    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = _calculateCrossAxisCount(width);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(CityConstants.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CityConstants.citySelectionSubtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: CityConstants.sectionSpacing),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: CityConstants.cardSpacing,
              mainAxisSpacing: CityConstants.cardSpacing,
              childAspectRatio: 0.9,
            ),
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              final isSelected = _selectedCity?.id == city.id;

              return CityCard(
                city: city,
                isSelected: isSelected,
                onTap: () => _onCitySelected(city),
              );
            },
          ),
        ],
      ),
    );
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 900) return 4; // Desktop
    if (width > 600) return 3; // Tablet
    if (width > 400) return 2; // Standard phone
    return 2; // Small phone (minimum 2 columns)
  }

  Widget _buildContinueButton(BuildContext context) {
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
            onPressed: _selectedCity != null ? _onContinue : null,
            child: const Text(CityConstants.continueButtonText),
          ),
        ),
      ),
    );
  }

  void _onCitySelected(CityEntity city) {
    setState(() {
      _selectedCity = city;
    });
  }

  void _onContinue() {
    if (_selectedCity != null) {
      context.read<CityCubit>().saveCity(_selectedCity!);
    }
  }

  void _handleStateChanges(BuildContext context, CityState state) {
    if (state is CitySaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate to home after successful save
      context.goNamed('home');
    }
  }
}
