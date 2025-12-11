import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/constants/owner_constants.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/field_form/add_edit_field_form.dart';

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

      _selectedSurface = _validateDropdownValue(
        widget.field!.surfaceType,
        OwnerConstants.surfaceTypes,
      );
      _selectedType = _validateDropdownValue(
        widget.field!.isIndoor ? 'Indoor' : 'Outdoor',
        OwnerConstants.fieldTypes,
      );
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
      return const Scaffold(
        body: Column(
          children: [
            PremiumCurvedHeader(
              title: 'Add Field',
              subtitle: 'Create a new football field',
              showBackButton: true,
              height: 160,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Creating new fields is currently restricted to Admins.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          PremiumCurvedHeader(
            title: 'Edit Field',
            subtitle: 'Update ${widget.field!.name}',
            showBackButton: true,
            height: 160,
          ),
          Expanded(
            child: BlocConsumer<OwnerCubit, OwnerState>(
              listener: (context, state) {
                if (state is OwnerActionSuccess) {
                  SnackbarHelper.showSuccess(context, state.message);
                  Navigator.pop(context);
                } else if (state is OwnerError) {
                  SnackbarHelper.showError(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is OwnerLoading) {
                  return const LoadingIndicator.fullScreen(
                    message: 'Updating field...',
                  );
                }

                return AddEditFieldForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  descriptionController: _descriptionController,
                  addressController: _addressController,
                  cityController: _cityController,
                  priceController: _priceController,
                  selectedSize: _selectedSize,
                  selectedSurface: _selectedSurface,
                  selectedType: _selectedType,
                  selectedFacilities: _selectedFacilities,
                  title: 'Edit Field',
                  subtitle: 'Update details for ${widget.field!.name}',
                  onSave: _handleSave,
                  onSizeChanged: (value) =>
                      setState(() => _selectedSize = value!),
                  onSurfaceChanged: (value) =>
                      setState(() => _selectedSurface = value!),
                  onTypeChanged: (value) =>
                      setState(() => _selectedType = value!),
                  onFacilityToggled: (facility) {
                    setState(() {
                      if (_selectedFacilities.contains(facility)) {
                        _selectedFacilities.remove(facility);
                      } else {
                        _selectedFacilities.add(facility);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final updates = <String, dynamic>{
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

  String _validateDropdownValue(String? value, List<String> allowed) {
    if (value != null && allowed.contains(value)) {
      return value;
    }
    return allowed.first;
  }
}
