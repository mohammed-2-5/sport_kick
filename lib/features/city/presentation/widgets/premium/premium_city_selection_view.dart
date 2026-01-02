import 'package:flutter/material.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/empty_states.dart';
import 'package:spo_kick/core/widgets/premium/premium_button.dart';
import 'package:spo_kick/features/city/domain/entities/city_entity.dart';
import 'package:spo_kick/features/city/presentation/widgets/premium/premium_city_grid.dart';

/// Premium city selection view.
///
/// Features:
/// - PremiumCurvedHeader with search
/// - Premium city grid
/// - Loading states
/// - Empty states
/// - Floating continue button
/// - Theme-aware: adapts to light/dark mode
class PremiumCitySelectionView extends StatefulWidget {
  final List<CityEntity> cities;
  final String? selectedCityId;
  final ValueChanged<CityEntity> onCitySelected;
  final VoidCallback onContinue;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const PremiumCitySelectionView({
    super.key,
    required this.cities,
    this.selectedCityId,
    required this.onCitySelected,
    required this.onContinue,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  State<PremiumCitySelectionView> createState() =>
      _PremiumCitySelectionViewState();
}

class _PremiumCitySelectionViewState extends State<PremiumCitySelectionView> {
  final TextEditingController _searchController = TextEditingController();
  List<CityEntity> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = widget.cities;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(PremiumCitySelectionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cities != oldWidget.cities) {
      _onSearchChanged();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCities = query.isEmpty
          ? widget.cities
          : widget.cities
                .where((city) => city.name.toLowerCase().contains(query))
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.darkNavyGradient
                  : AppColors.navyGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.citySelectionTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.citySelectionSubtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                // Search field
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: context.l10n.citySearchHint,
                      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      prefixIcon: Icon(
                        Icons.search,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(child: _buildContent()),
        ],
      ),
      // Continue button
      bottomNavigationBar: widget.isSaving
          ? LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.accentCyanLight : AppColors.accentCyan,
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: PremiumButton(
                  label: context.l10n.continueLabel,
                  onPressed: widget.selectedCityId != null
                      ? widget.onContinue
                      : null,
                  icon: Icons.arrow_forward,
                  fullWidth: true,
                ),
              ),
            ),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return LoadingIndicator.inline(message: context.l10n.cityLoading);
    }

    if (widget.errorMessage != null && widget.cities.isEmpty) {
      return EmptyStates.error(
        context,
        message: widget.errorMessage!,
        onRetry: widget.onRetry,
      );
    }

    if (_filteredCities.isEmpty) {
      return EmptyStates.noResults(
        context,
        onClear: () {
          _searchController.clear();
        },
      );
    }

    return PremiumCityGrid(
      cities: _filteredCities,
      selectedCityId: widget.selectedCityId,
      onCitySelected: widget.onCitySelected,
    );
  }
}
