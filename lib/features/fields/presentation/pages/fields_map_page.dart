import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_cubit.dart';
import 'package:spo_kick/features/fields/presentation/cubit/fields_state.dart';

/// Fields Map Page
///
/// Displays all available fields on an interactive map with markers.
/// Users can tap on markers to view field details and navigate to booking.
class FieldsMapPage extends StatefulWidget {
  const FieldsMapPage({super.key});

  @override
  State<FieldsMapPage> createState() => _FieldsMapPageState();
}

class _FieldsMapPageState extends State<FieldsMapPage> {
  final MapController _mapController = MapController();
  FieldEntity? _selectedField;

  // Default center: Cairo, Egypt
  static const LatLng _defaultCenter = LatLng(30.0444, 31.2357);
  static const double _defaultZoom = 11.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fields Map'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerOnUserLocation,
            tooltip: 'My Location',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: BlocBuilder<FieldsCubit, FieldsState>(
        builder: (context, state) {
          if (state is FieldsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is FieldsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<FieldsCubit>().loadAllFields();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is FieldsLoaded) {
            final fieldsWithLocation = state.fields
                .where((f) => f.hasLocation)
                .toList();

            if (fieldsWithLocation.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text(
                      'No fields with location data available',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                // Map
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _getInitialCenter(fieldsWithLocation),
                    initialZoom: _defaultZoom,
                    minZoom: 5.0,
                    maxZoom: 18.0,
                    onTap: (_, __) {
                      setState(() {
                        _selectedField = null;
                      });
                    },
                  ),
                  children: [
                    // OpenStreetMap Tile Layer
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.spo_kick',
                      maxZoom: 19,
                      subdomains: const ['a', 'b', 'c'],
                    ),

                    // Field Markers
                    MarkerLayer(
                      markers: fieldsWithLocation.map((field) {
                        return Marker(
                          point: LatLng(field.latitude!, field.longitude!),
                          width: 80,
                          height: 80,
                          alignment: Alignment.topCenter,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedField = field;
                              });
                              _mapController.move(
                                LatLng(field.latitude!, field.longitude!),
                                15.0,
                              );
                            },
                            child: _buildMarker(
                              field,
                              isSelected: _selectedField?.id == field.id,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // Field Info Card (when a field is selected)
                if (_selectedField != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildFieldInfoCard(_selectedField!),
                  ),

                // Fields Count Badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${fieldsWithLocation.length} Fields',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Build a custom marker for a field
  Widget _buildMarker(FieldEntity field, {required bool isSelected}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Marker Pin
        Container(
          padding: EdgeInsets.all(isSelected ? 12 : 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isSelected ? AppColors.secondary : AppColors.primary)
                    .withValues(alpha: 0.5),
                blurRadius: isSelected ? 16 : 12,
                spreadRadius: isSelected ? 3 : 2,
              ),
            ],
            border: Border.all(color: Colors.white, width: isSelected ? 4 : 3),
          ),
          child: Icon(
            Icons.sports_soccer,
            color: Colors.white,
            size: isSelected ? 22 : 18,
          ),
        ),
        // Pin Tail
        Container(
          width: 2,
          height: isSelected ? 10 : 8,
          color: isSelected ? AppColors.secondary : AppColors.primary,
        ),
      ],
    );
  }

  /// Build field info card shown at bottom when a field is selected
  Widget _buildFieldInfoCard(FieldEntity field) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Field Image
              if (field.hasImages)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    field.mainImage!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.sports_soccer, size: 40),
                    ),
                  ),
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.sports_soccer,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              const SizedBox(width: 16),
              // Field Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            field.address,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (field.hasReviews) ...[
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            field.ratingDisplay,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          field.formattedPrice,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedField = null;
                    });
                  },
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Close'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.pushNamed(
                      'fieldDetails',
                      pathParameters: {'fieldId': field.id},
                    );
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('View Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get initial center based on first field with location
  LatLng _getInitialCenter(List<FieldEntity> fields) {
    if (fields.isEmpty) return _defaultCenter;

    final firstField = fields.first;
    return LatLng(firstField.latitude!, firstField.longitude!);
  }

  /// Center map on user's current location
  void _centerOnUserLocation() {
    // TODO: Implement geolocation to get user's current location
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Show filter dialog
  void _showFilterDialog() {
    // TODO: Implement filter dialog for map view
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filter feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
