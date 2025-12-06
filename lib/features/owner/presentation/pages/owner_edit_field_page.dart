import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/edit_field_form.dart';

/// Edit field page for owners.
///
/// Allows field owners to update their field information including:
/// - Basic details (name, description, address)
/// - Pricing
/// - Field specifications (size, surface type)
/// - Facilities
/// - Active status
class OwnerEditFieldPage extends StatefulWidget {
  final FieldEntity field;

  const OwnerEditFieldPage({super.key, required this.field});

  @override
  State<OwnerEditFieldPage> createState() => _OwnerEditFieldPageState();
}

class _OwnerEditFieldPageState extends State<OwnerEditFieldPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;

  late String _selectedSize;
  late String _selectedSurface;
  late bool _isActive;
  late List<String> _selectedFacilities;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.field.name);
    _descriptionController = TextEditingController(
      text: widget.field.description ?? '',
    );
    _addressController = TextEditingController(text: widget.field.address);
    _priceController = TextEditingController(
      text: widget.field.pricePerHour.toStringAsFixed(0),
    );

    _selectedSize = widget.field.fieldSize;
    _selectedSurface = widget.field.surfaceType ?? 'Natural Grass';
    _isActive = widget.field.isActive;
    _selectedFacilities = List.from(widget.field.facilities);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Field')),
      body: BlocConsumer<OwnerCubit, OwnerState>(
        listener: (context, state) {
          if (state is OwnerError) {
            SnackbarHelper.showError(context, state.message);
          } else if (state is OwnerActionSuccess) {
            SnackbarHelper.showSuccess(context, state.message);
            // Navigate back after successful update
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final isLoading = state is OwnerLoading;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EditFieldForm(
                      nameController: _nameController,
                      descriptionController: _descriptionController,
                      addressController: _addressController,
                      priceController: _priceController,
                      selectedSize: _selectedSize,
                      selectedSurface: _selectedSurface,
                      isActive: _isActive,
                      selectedFacilities: _selectedFacilities,
                      onSizeChanged: (value) {
                        setState(() {
                          _selectedSize = value;
                        });
                      },
                      onSurfaceChanged: (value) {
                        setState(() {
                          _selectedSurface = value;
                        });
                      },
                      onActiveChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
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
                    CustomButton(
                      text: 'Save Changes',
                      onPressed: isLoading ? null : _handleSubmit,
                      isLoading: isLoading,
                      icon: Icons.save,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                      variant: ButtonVariant.outline,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      SnackbarHelper.showError(context, 'Please enter a valid price');
      return;
    }

    final updates = {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      'address': _addressController.text.trim(),
      'price_per_hour': price,
      'size': _selectedSize,
      'surface_type': _selectedSurface,
      'amenities': _selectedFacilities,
      'is_active': _isActive,
    };

    context.read<OwnerCubit>().updateField(widget.field.id, updates);
  }
}
