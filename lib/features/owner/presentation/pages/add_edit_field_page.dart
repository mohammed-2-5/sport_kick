import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/constants/owner_constants.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_facilities_selector.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_form_dropdown.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_form_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_form_section_header.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/field_form_text_field.dart';

/// Add/Edit Field Form Page
///
/// Allows owners to:
/// - Edit existing field details
/// - (Creation is currently disabled for owners)
class AddEditFieldPage extends StatefulWidget {
  final FieldEntity? field; // If provided, we are in edit mode

  const AddEditFieldPage({super.key, this.field});

  @override
  State<AddEditFieldPage> createState() => _AddEditFieldPageState();
}

class _AddEditFieldPageState extends State<AddEditFieldPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _priceController;

  String _selectedSize = OwnerConstants.fieldSizes.first;
  String _selectedSurface = OwnerConstants.surfaceTypes.first;
  String _selectedType = OwnerConstants.fieldTypes.first;
  List<String> _selectedFacilities = [];

  bool get _isEditing => widget.field != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.field?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.field?.description ?? '',
    );
    _addressController = TextEditingController(
      text: widget.field?.address ?? '',
    );
    _cityController = TextEditingController(text: widget.field?.city ?? '');
    _priceController = TextEditingController(
      text: widget.field?.pricePerHour.toString() ?? '',
    );

    if (_isEditing) {
      if (widget.field!.capacity != null) {
        if (widget.field!.capacity! <= 10) {
          _selectedSize = '5v5';
        } else if (widget.field!.capacity! <= 14) {
          _selectedSize = '7v7';
        } else {
          _selectedSize = '11v11';
        }
      }

      _selectedSurface =
          widget.field!.surfaceType ?? OwnerConstants.surfaceTypes.first;
      _selectedType = widget.field!.isIndoor ? 'Indoor' : 'Outdoor';
      _selectedFacilities = List.from(widget.field!.facilities);
    }
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
    if (!_isEditing) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add Field')),
        body: const Center(
          child: Text('Creating new fields is currently restricted to Admins.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Field'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primary),
        ),
      ),
      body: BlocConsumer<OwnerCubit, OwnerState>(
        listener: (context, state) {
          if (state is OwnerActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else if (state is OwnerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OwnerLoading) {
            return const LoadingIndicator.fullScreen(
              message: 'Updating field...',
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header Card
                FieldFormHeader(
                  title: 'Edit Field',
                  subtitle: 'Update details for ${widget.field!.name}',
                ),

                const SizedBox(height: 24),

                // Basic Information Section
                const FieldFormSectionHeader(
                  title: 'Basic Information',
                  icon: Icons.info_outline,
                ),
                const SizedBox(height: 16),

                FieldFormTextField(
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

                FieldFormTextField(
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
                const FieldFormSectionHeader(
                  title: 'Location',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 16),

                FieldFormTextField(
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

                FieldFormTextField(
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
                const FieldFormSectionHeader(
                  title: 'Field Details',
                  icon: Icons.settings_outlined,
                ),
                const SizedBox(height: 16),

                FieldFormDropdown(
                  label: 'Field Size',
                  value: _selectedSize,
                  items: OwnerConstants.fieldSizes,
                  icon: Icons.straighten_rounded,
                  onChanged: (value) {
                    setState(() => _selectedSize = value!);
                  },
                ),

                const SizedBox(height: 16),

                FieldFormDropdown(
                  label: 'Surface Type',
                  value: _selectedSurface,
                  items: OwnerConstants.surfaceTypes,
                  icon: Icons.grass_rounded,
                  onChanged: (value) {
                    setState(() => _selectedSurface = value!);
                  },
                ),

                const SizedBox(height: 16),

                FieldFormDropdown(
                  label: 'Field Type',
                  value: _selectedType,
                  items: OwnerConstants.fieldTypes,
                  icon: Icons.wb_sunny_outlined,
                  onChanged: (value) {
                    setState(() => _selectedType = value!);
                  },
                ),

                const SizedBox(height: 24),

                // Pricing Section
                const FieldFormSectionHeader(
                  title: 'Pricing',
                  icon: Icons.attach_money_rounded,
                ),
                const SizedBox(height: 16),

                FieldFormTextField(
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
                const FieldFormSectionHeader(
                  title: 'Facilities',
                  icon: Icons.widgets_outlined,
                ),
                const SizedBox(height: 16),

                FieldFacilitiesSelector(
                  selectedFacilities: _selectedFacilities,
                  onFacilityToggled: (facility) {
                    setState(() {
                      if (_selectedFacilities.contains(facility)) {
                        _selectedFacilities.remove(facility);
                      } else {
                        _selectedFacilities.add(facility);
                      }
                    });
                  },
                ),

                const SizedBox(height: 32),

                // Save Button
                CustomButton(
                  text: 'Update Field',
                  onPressed: _handleSave,
                  variant: ButtonVariant.primary,
                  icon: Icons.check_rounded,
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final updates = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'price_per_hour': double.parse(_priceController.text),
        'size': _selectedSize,
        'surface': _selectedSurface,
        'type': _selectedType,
        'facilities': _selectedFacilities,
      };

      context.read<OwnerCubit>().updateField(widget.field!.id, updates);
    }
  }
}
