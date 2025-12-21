import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/models/location_data.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/field_form_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_field/create_field_form_body.dart';

import '../../../../core/localization/l10n_extensions.dart';

/// Edit Field Page for Super Admin
///
/// Allows super admin to edit existing field details.
/// Pre-populates form with current field data.
class EditFieldPage extends StatefulWidget {
  final FieldEntity field;

  const EditFieldPage({super.key, required this.field});

  @override
  State<EditFieldPage> createState() => _EditFieldPageState();
}

class _EditFieldPageState extends State<EditFieldPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;
  late final TextEditingController _priceController;

  UserEntity? _selectedAdmin;
  String? _selectedCity;
  String? _selectedSportCategory;
  late String _selectedSize;
  late String _selectedSurface;
  late bool _isIndoor;
  late List<String> _selectedFacilities;
  String? _paymentPhone;
  String _paymentMethod = 'vodafone_cash';
  LocationData? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _initializeFormWithFieldData();
  }

  void _initializeFormWithFieldData() {
    final field = widget.field;

    _nameController = TextEditingController(text: field.name);
    _descriptionController = TextEditingController(
      text: field.description ?? '',
    );
    _addressController = TextEditingController(text: field.address);
    _priceController = TextEditingController(
      text: field.pricePerHour.toString(),
    );

    _selectedCity = field.city;
    _selectedSportCategory = field.sportCategoryId;
    _selectedSize = _mapCapacityToSize(field.capacity);
    _selectedSurface = field.surfaceType ?? FieldFormConstants.defaultSurface;
    _isIndoor = field.isIndoor;
    _selectedFacilities = List<String>.from(field.facilities);

    // Initialize location if coordinates are available
    if (field.latitude != null && field.longitude != null) {
      _selectedLocation = LocationData(
        address: field.address,
        latitude: field.latitude!,
        longitude: field.longitude!,
      );
    }
  }

  String _mapCapacityToSize(int? capacity) {
    if (capacity == null) return FieldFormConstants.defaultSize;
    if (capacity <= 10) return '5-a-side';
    if (capacity <= 14) return '7-a-side';
    return '11-a-side';
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
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()
        ..loadAdmins()
        ..loadCities(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.editField),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppGradients.primary),
          ),
        ),
        body: BlocConsumer<SuperAdminCubit, SuperAdminState>(
          listener: (context, state) {
            if (state is FieldUpdated) {
              SnackbarHelper.showSuccess(context, state.successMessage);
              Navigator.of(context).pop(true); // Return true to indicate update
            }

            if (state is SuperAdminError) {
              SnackbarHelper.showError(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is SuperAdminLoading) {
              return LoadingIndicator.inline(message: state.message);
            }

            // Extract data from state
            List<UserEntity> admins = [];
            List<CityEntity> cities = [];
            Map<String, String> sportCategories = {};
            bool isLoadingAdmins = true;
            bool isLoadingCities = true;

            if (state is AdminsListLoaded) {
              admins = state.admins;
              isLoadingAdmins = false;

              // Try to find and set the current admin
              if (_selectedAdmin == null && widget.field.ownerId != null) {
                _selectedAdmin = admins
                    .where((a) => a.id == widget.field.ownerId)
                    .firstOrNull;
              }
            }

            if (state is CitiesLoaded) {
              cities = state.cities;
              isLoadingCities = false;
            }

            return CreateFieldFormBody(
              formKey: _formKey,
              nameController: _nameController,
              descriptionController: _descriptionController,
              addressController: _addressController,
              priceController: _priceController,
              selectedAdmin: _selectedAdmin,
              selectedCity: _selectedCity,
              selectedSportCategory: _selectedSportCategory,
              selectedSize: _selectedSize,
              selectedSurface: _selectedSurface,
              isIndoor: _isIndoor,
              selectedFacilities: _selectedFacilities,
              paymentPhone: _paymentPhone,
              paymentMethod: _paymentMethod,
              admins: admins,
              cities: cities,
              sportCategories: sportCategories,
              sizes: FieldFormConstants.sizes,
              surfaces: FieldFormConstants.surfaces,
              availableFacilities: FieldFormConstants.facilities,
              isLoadingAdmins: isLoadingAdmins,
              isLoadingCities: isLoadingCities,
              isLoadingSportCategories: false,
              onAdminChanged: (v) => setState(() => _selectedAdmin = v),
              onCityChanged: (v) => setState(() => _selectedCity = v),
              onSportCategoryChanged: (v) =>
                  setState(() => _selectedSportCategory = v),
              onSizeChanged: (v) => setState(() => _selectedSize = v),
              onSurfaceChanged: (v) => setState(() => _selectedSurface = v),
              onIndoorChanged: (v) => setState(() => _isIndoor = v),
              onFacilitiesChanged: (v) =>
                  setState(() => _selectedFacilities = v),
              onPaymentPhoneChanged: (v) => setState(() => _paymentPhone = v),
              onPaymentMethodChanged: (v) => setState(() => _paymentMethod = v),
              selectedLocation: _selectedLocation,
              onLocationChanged: (v) => setState(() => _selectedLocation = v),
              submitButtonLabel: 'Update Field',
              onSubmit: _handleSubmit,
            );
          },
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_priceController.text.trim());
    if (price == null) {
      SnackbarHelper.showError(context, 'Invalid price');
      return;
    }

    context.read<SuperAdminCubit>().updateField(
      fieldId: widget.field.id,
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      pricePerHour: price,
      latitude: _selectedLocation?.latitude,
      longitude: _selectedLocation?.longitude,
      ownerId: _selectedAdmin?.id,
      surfaceType: _selectedSurface,
      isIndoor: _isIndoor,
      facilities: _selectedFacilities,
      paymentPhone: _paymentPhone,
      paymentMethod: _paymentMethod,
    );
  }
}
