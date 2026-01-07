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
import 'package:spo_kick/features/super_admin/presentation/cubit/field_management/field_management_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/field_management/field_management_state.dart'
    as field_mgmt;
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
  String _selectedSize = FieldFormConstants.defaultSize;
  String _selectedSurface = FieldFormConstants.defaultSurface;
  bool _isIndoor = FieldFormConstants.defaultIsIndoor;
  List<String> _selectedFacilities = [];
  String? _paymentPhone;
  String _paymentMethod = 'vodafone_cash';
  LocationData? _selectedLocation;

  bool _isFormInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _initializeControllersFromFormData(field_mgmt.FieldFormData formData) {
    if (_isFormInitialized) return;

    _nameController.text = formData.name;
    _descriptionController.text = formData.description;
    _addressController.text = formData.address;
    _priceController.text = formData.pricePerHour;

    _selectedCity = formData.city;
    _selectedSportCategory = formData.sportCategoryId;
    _selectedSize = formData.size;
    _selectedSurface = formData.surface;
    _isIndoor = formData.isIndoor;
    _selectedFacilities = List<String>.from(formData.facilities);
    _paymentPhone = formData.paymentPhone;
    _paymentMethod = formData.paymentMethod;

    if (formData.latitude != null && formData.longitude != null) {
      _selectedLocation = LocationData(
        address: formData.address,
        latitude: formData.latitude!,
        longitude: formData.longitude!,
      );
    }

    _isFormInitialized = true;
  }

  void _handleSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<FieldManagementCubit>().submitFieldUpdate(
      fieldId: widget.field.id,
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      description: _descriptionController.text.trim(),
      priceText: _priceController.text.trim(),
      size: _selectedSize,
      surface: _selectedSurface,
      isIndoor: _isIndoor,
      facilities: _selectedFacilities,
      paymentPhone: _paymentPhone,
      paymentMethod: _paymentMethod,
      latitude: _selectedLocation?.latitude,
      longitude: _selectedLocation?.longitude,
      ownerId: _selectedAdmin?.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<SuperAdminCubit>()
            ..loadAdmins()
            ..loadCities(),
        ),
        BlocProvider(
          create: (_) =>
              sl<FieldManagementCubit>()..initializeFieldForm(widget.field),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.editField),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppGradients.primary),
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<FieldManagementCubit, field_mgmt.FieldManagementState>(
              listener: (context, state) {
                if (state is field_mgmt.FieldFormInitialized) {
                  setState(() {
                    _initializeControllersFromFormData(state.formData);
                  });
                }

                if (state is field_mgmt.FieldUpdated) {
                  SnackbarHelper.showSuccess(context, state.successMessage);
                  Navigator.of(context).pop(true);
                }

                if (state is field_mgmt.FieldManagementError) {
                  SnackbarHelper.showError(context, state.message);
                }
              },
            ),
            BlocListener<SuperAdminCubit, SuperAdminState>(
              listener: (context, state) {
                if (state is SuperAdminError) {
                  SnackbarHelper.showError(context, state.message);
                }
              },
            ),
          ],
          child:
              BlocBuilder<
                FieldManagementCubit,
                field_mgmt.FieldManagementState
              >(
                builder: (context, fieldManagementState) {
                  if (fieldManagementState
                      is field_mgmt.FieldManagementLoading) {
                    return LoadingIndicator.inline(
                      message: fieldManagementState.message,
                    );
                  }

                  return BlocBuilder<SuperAdminCubit, SuperAdminState>(
                    builder: (context, superAdminState) {
                      if (superAdminState is SuperAdminLoading) {
                        return LoadingIndicator.inline(
                          message: superAdminState.message,
                        );
                      }

                      List<UserEntity> admins = [];
                      List<CityEntity> cities = [];
                      Map<String, String> sportCategories = {};
                      bool isLoadingAdmins = true;
                      bool isLoadingCities = true;

                      if (superAdminState is AdminsListLoaded) {
                        admins = superAdminState.admins;
                        isLoadingAdmins = false;

                        if (_selectedAdmin == null &&
                            widget.field.ownerId != null) {
                          _selectedAdmin = admins
                              .where((a) => a.id == widget.field.ownerId)
                              .firstOrNull;
                        }
                      }

                      if (superAdminState is CitiesLoaded) {
                        cities = superAdminState.cities;
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
                        onAdminChanged: (v) =>
                            setState(() => _selectedAdmin = v),
                        onCityChanged: (v) => setState(() => _selectedCity = v),
                        onSportCategoryChanged: (v) =>
                            setState(() => _selectedSportCategory = v),
                        onSizeChanged: (v) => setState(() => _selectedSize = v),
                        onSurfaceChanged: (v) =>
                            setState(() => _selectedSurface = v),
                        onIndoorChanged: (v) => setState(() => _isIndoor = v),
                        onFacilitiesChanged: (v) =>
                            setState(() => _selectedFacilities = v),
                        onPaymentPhoneChanged: (v) =>
                            setState(() => _paymentPhone = v),
                        onPaymentMethodChanged: (v) =>
                            setState(() => _paymentMethod = v),
                        selectedLocation: _selectedLocation,
                        onLocationChanged: (v) =>
                            setState(() => _selectedLocation = v),
                        submitButtonLabel: 'Update Field',
                        onSubmit: () => _handleSubmit(context),
                      );
                    },
                  );
                },
              ),
        ),
      ),
    );
  }
}
