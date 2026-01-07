import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/models/location_data.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/models/field_creation_data.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/field_form_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/field_management/field_management_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/field_management/field_management_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_field/create_field_form_body.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_field/field_creation_success_dialog.dart';

import '../../../../core/localization/l10n_extensions.dart';

/// Create Field Page for Super Admin
///
/// Allows super admin to create new fields and assign them to admins.
/// All business logic and validation handled by FieldManagementCubit.
class CreateFieldPage extends StatefulWidget {
  const CreateFieldPage({super.key});

  @override
  State<CreateFieldPage> createState() => _CreateFieldPageState();
}

class _CreateFieldPageState extends State<CreateFieldPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();

  UserEntity? _selectedAdmin;
  String? _selectedCity;
  String? _selectedSportCategory;
  String _selectedSize = FieldFormConstants.defaultSize;
  String _selectedSurface = FieldFormConstants.defaultSurface;
  bool _isIndoor = FieldFormConstants.defaultIsIndoor;
  List<String> _selectedFacilities = [];
  String? _paymentPhone = '01068700814';
  String _paymentMethod = 'vodafone_cash';
  LocationData? _selectedLocation;

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
      create: (_) => sl<FieldManagementCubit>()..loadFormData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.createNewField2),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppGradients.primary),
          ),
        ),
        body: BlocConsumer<FieldManagementCubit, FieldManagementState>(
          listener: (context, state) {
            if (state is FieldCreated) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) =>
                    FieldCreationSuccessDialog(message: state.successMessage),
              );
            }

            if (state is FieldManagementError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            // Show loading while creating field
            if (state is FieldManagementLoading) {
              return LoadingIndicator.inline(message: state.message);
            }

            // Extract data from FormDataLoaded state
            List<UserEntity> admins = [];
            List<CityEntity> cities = [];
            Map<String, String> sportCategories = {};

            if (state is FormDataLoaded) {
              admins = state.admins;
              cities = state.cities;
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
              isLoadingAdmins: state is! FormDataLoaded,
              isLoadingCities: state is! FormDataLoaded,
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
              onSubmit: () {
                // Only validate form fields, cubit handles rest
                if (!_formKey.currentState!.validate()) return;

                // Collect data and pass to cubit
                final data = FieldCreationData(
                  adminId: _selectedAdmin?.id,
                  name: _nameController.text.trim(),
                  description: _descriptionController.text.trim(),
                  address: _addressController.text.trim(),
                  city: _selectedCity,
                  priceText: _priceController.text.trim(),
                  sportCategory: _selectedSportCategory,
                  size: _selectedSize,
                  surface: _selectedSurface,
                  isIndoor: _isIndoor,
                  facilities: _selectedFacilities,
                  paymentPhone: _paymentPhone,
                  paymentMethod: _paymentMethod,
                );

                // Cubit handles all validation and logic
                context.read<FieldManagementCubit>().submitFieldCreation(
                  data,
                  sportCategories,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
