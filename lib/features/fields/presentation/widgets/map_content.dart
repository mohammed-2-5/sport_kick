import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/fields/presentation/widgets/map_field_info_card.dart';
import 'package:spo_kick/features/fields/presentation/widgets/map_fields_count_badge.dart';
import 'package:spo_kick/features/fields/presentation/widgets/map_filter_indicator.dart';
import 'package:spo_kick/features/fields/presentation/widgets/map_marker.dart';

/// Main map content widget.
class MapContent extends StatefulWidget {
  final List<FieldEntity> fields;
  final MapController mapController;

  const MapContent({
    super.key,
    required this.fields,
    required this.mapController,
  });

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  FieldEntity? _selectedField;
  static const LatLng _defaultCenter = LatLng(30.0444, 31.2357);
  static const double _defaultZoom = 11.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map
        FlutterMap(
          mapController: widget.mapController,
          options: MapOptions(
            initialCenter: _getInitialCenter(widget.fields),
            initialZoom: _defaultZoom,
            minZoom: 5.0,
            maxZoom: 18.0,
            onTap: (tapPosition, point) {
              setState(() {
                _selectedField = null;
              });
            },
          ),
          children: [
            // OpenStreetMap Tile Layer
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.spo_kick',
              maxZoom: 19,
              subdomains: const ['a', 'b', 'c'],
            ),

            // Field Markers
            MarkerLayer(
              markers: widget.fields.map((field) {
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
                      widget.mapController.move(
                        LatLng(field.latitude!, field.longitude!),
                        15.0,
                      );
                    },
                    child: MapMarker(
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
            child: MapFieldInfoCard(
              field: _selectedField!,
              onClose: () {
                setState(() {
                  _selectedField = null;
                });
              },
            ),
          ),

        // Fields Count Badge
        Positioned(
          top: 16,
          left: 16,
          child: MapFieldsCountBadge(count: widget.fields.length),
        ),

        // Filter indicator
        const Positioned(top: 16, right: 16, child: MapFilterIndicator()),
      ],
    );
  }

  /// Get initial center based on first field with location
  LatLng _getInitialCenter(List<FieldEntity> fields) {
    if (fields.isEmpty) return _defaultCenter;

    final firstField = fields.first;
    return LatLng(firstField.latitude!, firstField.longitude!);
  }
}
