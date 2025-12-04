import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/domain/entities/city_entity.dart';
import 'package:spo_kick/features/super_admin/domain/models/field_creation_data.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/field_form_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_field/create_field_form_body.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_field/field_creation_success_dialog.dart';

/// Create Field Page for Super Admin
///
/// Allows super admin to create new fields and assign them to admins.
/// All business logic and validation handled by cubit.
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
          title: const Text('Create New Field'),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: AppGradients.primary),
          ),
        ),
        body: BlocConsumer<SuperAdminCubit, SuperAdminState>(
          listener: (context, state) {
            if (state is FieldCreated) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) =>
                    FieldCreationSuccessDialog(message: state.successMessage),
              );
            }

            if (state is SuperAdminError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is SuperAdminLoading) {
              return const LoadingIndicator.inline(
                message: 'Creating field...',
              );
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
            }

            if (state is CitiesLoaded) {
              cities = state.cities;
              isLoadingCities = false;
            }

            // TODO: Load sport categories from fields feature

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
                );

                // Cubit handles all validation and logic
                context.read<SuperAdminCubit>().submitFieldCreation(
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
