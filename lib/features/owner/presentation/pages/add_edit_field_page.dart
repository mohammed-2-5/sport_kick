import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/owner/domain/constants/owner_constants.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_fields/owner_fields_crud_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_fields/owner_fields_crud_state.dart';
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

    // Initialize controllers with empty values
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _priceController = TextEditingController();

    // Request form initialization from cubit if in edit mode
    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<OwnerFieldsCrudCubit>().initializeFieldForm(widget.field);
      });
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

  /// Populate form controllers and state from cubit-provided form data.
  ///
  /// This method only handles UI state synchronization.
  /// Business logic (data mapping/validation) is handled by the cubit.
  void _populateFormFromData(Map<String, dynamic> formData) {
    _nameController.text = formData['name'] as String? ?? '';
    _descriptionController.text = formData['description'] as String? ?? '';
    _addressController.text = formData['address'] as String? ?? '';
    _cityController.text = formData['city'] as String? ?? '';
    _priceController.text = formData['pricePerHour'] as String? ?? '';

    setState(() {
      _selectedSize =
          formData['size'] as String? ?? OwnerConstants.fieldSizes.first;
      _selectedSurface =
          formData['surface'] as String? ?? OwnerConstants.surfaceTypes.first;
      _selectedType =
          formData['type'] as String? ?? OwnerConstants.fieldTypes.first;
      _selectedFacilities = List<String>.from(
        formData['facilities'] as List? ?? [],
      );
    });
  }

  /// Handle form save by delegating to cubit.
  ///
  /// Only performs UI-level validation, delegates business logic to cubit.
  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final formData = <String, dynamic>{
        'name': _nameController.text,
        'description': _descriptionController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'pricePerHour': _priceController.text,
        'size': _selectedSize,
        'surface': _selectedSurface,
        'type': _selectedType,
        'facilities': _selectedFacilities,
      };

      context.read<OwnerFieldsCrudCubit>().submitFieldUpdate(
        widget.field!.id,
        formData,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing) {
      return Scaffold(
        body: Column(
          children: [
            PremiumCurvedHeader(
              title: context.l10n.addFieldTitle,
              subtitle: context.l10n.addFieldSubtitle,
              showBackButton: true,
              height: 160,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    context.l10n.createFieldRestrictedMessage,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge,
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
            title: context.l10n.editFieldTitle,
            subtitle: context.l10n.updateFieldTitle(widget.field!.name),
            showBackButton: true,
            height: 160,
          ),
          Expanded(
            child: BlocConsumer<OwnerFieldsCrudCubit, OwnerFieldsCrudState>(
              listener: (context, state) {
                if (state is FieldFormInitialized) {
                  _populateFormFromData(state.formData);
                } else if (state is FieldUpdated) {
                  SnackbarHelper.showSuccess(
                    context,
                    'Field updated successfully',
                  );
                  Navigator.pop(context);
                } else if (state is OwnerFieldsCrudError) {
                  SnackbarHelper.showError(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is OwnerFieldsCrudLoading) {
                  return LoadingIndicator.fullScreen(message: state.message);
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
                  title: context.l10n.editFieldTitle,
                  subtitle: context.l10n.updateFieldDetailsSubtitle(
                    widget.field!.name,
                  ),
                  onSave: _handleSave,
                  onManageBusinessHours: () => context.pushNamed(
                    'manageBusinessHours',
                    extra: widget.field!.id,
                  ),
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
}
