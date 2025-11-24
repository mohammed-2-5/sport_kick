import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';

/// Add/Edit Field Form Page
///
/// Allows owners to:
/// - Add new football fields
/// - Edit existing field details
/// - Upload field images
/// - Set pricing and availability
class AddEditFieldPage extends StatefulWidget {
  final String? fieldId; // null for add, id for edit

  const AddEditFieldPage({super.key, this.fieldId});

  @override
  State<AddEditFieldPage> createState() => _AddEditFieldPageState();
}

class _AddEditFieldPageState extends State<AddEditFieldPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedSize = '5v5';
  String _selectedSurface = 'Natural Grass';
  String _selectedType = 'Outdoor';
  List<String> _selectedFacilities = [];

  final List<String> _sizes = ['5v5', '7v7', '11v11'];
  final List<String> _surfaces = ['Natural Grass', 'Artificial Turf', 'Indoor'];
  final List<String> _types = ['Outdoor', 'Indoor'];
  final List<String> _availableFacilities = [
    'Parking',
    'Changing Room',
    'Shower',
    'Cafeteria',
    'WiFi',
    'Lighting',
  ];

  bool get _isEditing => widget.fieldId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadFieldData();
    }
  }

  void _loadFieldData() {
    // TODO: Load field data for editing
    // For now, using placeholder data
    _nameController.text = 'Sample Field';
    _descriptionController.text = 'A great football field';
    _addressController.text = '123 Main St';
    _cityController.text = 'Los Angeles';
    _priceController.text = '50';
    _selectedFacilities = ['Parking', 'Lighting'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Field' : 'Add New Field'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.primary,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppShadows.medium,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _isEditing ? Icons.edit_rounded : Icons.add_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEditing ? 'Edit Field' : 'Create New Field',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Fill in the details below',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Basic Information Section
            _buildSectionHeader('Basic Information', Icons.info_outline),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _nameController,
              label: 'Field Name',
              hint: 'e.g., Premium Soccer Field',
              icon: Icons.sports_soccer_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter field name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe your field...',
              icon: Icons.description_outlined,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Location Section
            _buildSectionHeader('Location', Icons.location_on_outlined),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _addressController,
              label: 'Address',
              hint: 'Street address',
              icon: Icons.home_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _cityController,
              label: 'City',
              hint: 'e.g., Los Angeles',
              icon: Icons.location_city_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter city';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Field Details Section
            _buildSectionHeader('Field Details', Icons.settings_outlined),
            const SizedBox(height: 16),

            _buildDropdown(
              label: 'Field Size',
              value: _selectedSize,
              items: _sizes,
              icon: Icons.straighten_rounded,
              onChanged: (value) {
                setState(() => _selectedSize = value!);
              },
            ),

            const SizedBox(height: 16),

            _buildDropdown(
              label: 'Surface Type',
              value: _selectedSurface,
              items: _surfaces,
              icon: Icons.grass_rounded,
              onChanged: (value) {
                setState(() => _selectedSurface = value!);
              },
            ),

            const SizedBox(height: 16),

            _buildDropdown(
              label: 'Field Type',
              value: _selectedType,
              items: _types,
              icon: Icons.wb_sunny_outlined,
              onChanged: (value) {
                setState(() => _selectedType = value!);
              },
            ),

            const SizedBox(height: 24),

            // Pricing Section
            _buildSectionHeader('Pricing', Icons.attach_money_rounded),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _priceController,
              label: 'Price per Hour',
              hint: 'e.g., 50',
              icon: Icons.payments_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Facilities Section
            _buildSectionHeader('Facilities', Icons.widgets_outlined),
            const SizedBox(height: 16),

            _buildFacilitiesSelector(),

            const SizedBox(height: 32),

            // Save Button
            CustomButton(
              text: _isEditing ? 'Update Field' : 'Create Field',
              onPressed: _handleSave,
              variant: ButtonVariant.primary,
              icon: _isEditing ? Icons.check_rounded : Icons.add_rounded,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: AppShadows.small,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: value,
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
            underline: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableFacilities.map((facility) {
        final isSelected = _selectedFacilities.contains(facility);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedFacilities.remove(facility);
              } else {
                _selectedFacilities.add(facility);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? AppGradients.primary
                  : null,
              color: isSelected ? null : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : AppColors.divider,
                width: 1.5,
              ),
              boxShadow: isSelected ? AppShadows.small : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getFacilityIcon(facility),
                  size: 18,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  facility,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getFacilityIcon(String facility) {
    switch (facility) {
      case 'Parking':
        return Icons.local_parking_rounded;
      case 'Changing Room':
        return Icons.checkroom_rounded;
      case 'Shower':
        return Icons.shower_rounded;
      case 'Cafeteria':
        return Icons.restaurant_rounded;
      case 'WiFi':
        return Icons.wifi_rounded;
      case 'Lighting':
        return Icons.lightbulb_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save logic (create or update field)

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Field updated successfully'
                : 'Field created successfully',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    }
  }
}
