import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';

/// Field comparison page - compare multiple fields side-by-side.
///
/// Allows users to compare up to 3 fields to make informed booking decisions.
class FieldComparisonPage extends StatelessWidget {
  final List<FieldEntity> fields;

  const FieldComparisonPage({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Fields'), elevation: 0),
      body: fields.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(child: _buildComparisonTable()),
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.compare_arrows,
              size: 80,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 24),
            Text(
              'No fields to compare',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Select fields from the list to compare them',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    return DataTable(
      columnSpacing: 20,
      headingRowColor: WidgetStateProperty.all(
        AppColors.primaryLight.withValues(alpha: 0.1),
      ),
      columns: [
        const DataColumn(
          label: Text(
            'Feature',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ...fields.map(
          (field) => DataColumn(
            label: SizedBox(
              width: 150,
              child: Text(
                field.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
      rows: [
        // Image Row
        DataRow(
          cells: [
            const DataCell(
              Text('Image', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ...fields.map(
              (field) => DataCell(
                field.hasImages
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          field.mainImage!,
                          width: 100,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.sports_soccer),
                      ),
              ),
            ),
          ],
        ),

        // Price Row
        DataRow(
          cells: [
            const DataCell(
              Text('Price/Hour', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ...fields.map(
              (field) => DataCell(
                Text(
                  field.formattedPrice,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Rating Row
        DataRow(
          cells: [
            const DataCell(
              Text('Rating', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ...fields.map(
              (field) => DataCell(
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      field.hasReviews ? field.ratingDisplay : 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Reviews Row
        DataRow(
          cells: [
            const DataCell(
              Text('Reviews', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ...fields.map(
              (field) => DataCell(
                Text(field.hasReviews ? '${field.totalReviews}' : 'No reviews'),
              ),
            ),
          ],
        ),

        // Capacity Row
        DataRow(
          cells: [
            const DataCell(
              Text('Capacity', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ...fields.map((field) => DataCell(Text(field.fieldSize))),
          ],
        ),

        // Surface Type Row
        DataRow(
          cells: [
            const DataCell(
              Text('Surface', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ...fields.map(
              (field) => DataCell(Text(field.surfaceType ?? 'Not specified')),
            ),
          ],
        ),

        // Location Type Row
        DataRow(
          cells: [
            const DataCell(
              Text('Location', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ...fields.map(
              (field) => DataCell(
                Row(
                  children: [
                    Icon(
                      field.isIndoor ? Icons.home : Icons.wb_sunny,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(field.isIndoor ? 'Indoor' : 'Outdoor'),
                  ],
                ),
              ),
            ),
          ],
        ),

        // City Row
        DataRow(
          cells: [
            const DataCell(
              Text('City', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ...fields.map(
              (field) => DataCell(
                Row(
                  children: [
                    const Icon(
                      Icons.location_city,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(field.city),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Verified Row
        DataRow(
          cells: [
            const DataCell(
              Text('Verified', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ...fields.map(
              (field) => DataCell(
                Icon(
                  field.isVerified ? Icons.verified : Icons.cancel,
                  color: field.isVerified ? AppColors.success : AppColors.error,
                  size: 20,
                ),
              ),
            ),
          ],
        ),

        // Facilities Row
        DataRow(
          cells: [
            const DataCell(
              Text('Facilities', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ...fields.map(
              (field) => DataCell(
                SizedBox(
                  width: 150,
                  child: Text(
                    field.hasFacilities
                        ? field.facilities.take(3).join(', ')
                        : 'None listed',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Total Bookings Row
        DataRow(
          cells: [
            const DataCell(
              Text('Popularity', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ...fields.map(
              (field) => DataCell(Text('${field.totalBookings} bookings')),
            ),
          ],
        ),
      ],
    );
  }
}
