import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/constants/app_shadows.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/custom_button.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Create Field Page for Super Admin
///
/// Allows super admin to create new fields and assign them to admins.
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
  List<UserEntity> _admins = [];
  bool _isLoadingAdmins = true;

  String? _selectedCity;
  List<String> _cities = [];
  bool _isLoadingCities = true;

  String? _selectedSportCategory;
  Map<String, String> _sportCategories = {}; // name -> id
  bool _isLoadingSportCategories = true;

  String _selectedSize = '5v5';
  String _selectedSurface = 'Natural Grass';
  bool _isIndoor = false;
  List<String> _selectedFacilities = [];

  final List<String> _sizes = ['5v5', '7v7', '11v11'];
  final List<String> _surfaces = ['Natural Grass', 'Artificial Turf', 'Hybrid'];
  final List<String> _availableFacilities = [
    'Parking',
    'Changing Room',
    'Shower',
    'Cafeteria',
    'WiFi',
    'Lighting',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAdmin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an admin to assign this field'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a city'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedSportCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a sport category'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null) {
      return;
    }

    int capacity = _selectedSize == '5v5'
        ? 10
        : _selectedSize == '7v7'
        ? 14
        : 22;

    final sportCategoryId =
        _sportCategories[_selectedSportCategory] ?? 'football-category-id';

    context.read<SuperAdminCubit>().createField(
      ownerId: _selectedAdmin!.id,
      sportCategoryId: sportCategoryId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      address: _addressController.text.trim(),
      city: _selectedCity!,
      pricePerHour: price,
      surfaceType: _selectedSurface,
      capacity: capacity,
      isIndoor: _isIndoor,
      facilities: _selectedFacilities,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCities();
    _loadSportCategories();
  }

  Future<void> _loadCities() async {
    try {
      final response = await Supabase.instance.client
          .from('cities')
          .select('name')
          .eq('is_active', true)
          .order('name');

      setState(() {
        _cities = (response as List).map((e) => e['name'] as String).toList();
        _isLoadingCities = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCities = false;
      });
    }
  }

  Future<void> _loadSportCategories() async {
    try {
      final response = await Supabase.instance.client
          .from('sport_categories')
          .select('id, name')
          .order('name');

      setState(() {
        _sportCategories = Map.fromEntries(
          (response as List).map(
            (e) => MapEntry(e['name'] as String, e['id'] as String),
          ),
        );
        _isLoadingSportCategories = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSportCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuperAdminCubit>()..loadAdmins(),
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
            if (state is AdminsListLoaded) {
              setState(() {
                _admins = state.admins;
                _isLoadingAdmins = false;
              });
            }

            if (state is FieldCreated) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Text('Success!'),
                    ],
                  ),
                  content: Text(state.successMessage),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
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

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                    'Assign to Admin',
                    Icons.admin_panel_settings,
                  ),
                  const SizedBox(height: 12),
                  _buildAdminDropdown(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Basic Information', Icons.info_outline),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Field Name',
                    hint: 'e.g., Champions Field',
                    icon: Icons.sports_soccer,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description (Optional)',
                    hint: 'Brief description',
                    icon: Icons.description_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Location', Icons.location_on_outlined),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Address',
                    hint: 'Street address',
                    icon: Icons.home_outlined,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildCityDropdown(),
                  const SizedBox(height: 16),
                  _buildSportCategoryDropdown(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Field Details', Icons.settings_outlined),
                  const SizedBox(height: 12),
                  _buildDropdown(
                    label: 'Field Size',
                    value: _selectedSize,
                    items: _sizes,
                    onChanged: (v) => setState(() => _selectedSize = v!),
                    icon: Icons.straighten_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Surface Type',
                    value: _selectedSurface,
                    items: _surfaces,
                    onChanged: (v) => setState(() => _selectedSurface = v!),
                    icon: Icons.grass_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildIndoorSwitch(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Pricing', Icons.monetization_on_outlined),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _priceController,
                    label: 'Price per Hour (EGP)',
                    hint: '200',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Facilities', Icons.business_outlined),
                  const SizedBox(height: 12),
                  _buildFacilitiesSelector(),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Create Field',
                    onPressed: () => _handleSubmit(context),
                    icon: Icons.add_rounded,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.medium,
      ),
      child: const Row(
        children: [
          Icon(Icons.add_business_rounded, size: 32, color: Colors.white),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Field',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Fill in details and assign to admin',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAdminDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: AppShadows.small,
      ),
      child: _isLoadingAdmins
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading admins...'),
                ],
              ),
            )
          : DropdownButtonFormField<UserEntity>(
              value: _selectedAdmin,
              decoration: const InputDecoration(
                labelText: 'Select Admin',
                prefixIcon: Icon(Icons.person_outline),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: _admins.map((admin) {
                return DropdownMenuItem<UserEntity>(
                  value: admin,
                  child: Text(admin.fullName ?? admin.email),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedAdmin = v),
              validator: (v) => v == null ? 'Please select an admin' : null,
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: AppShadows.small,
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: AppShadows.small,
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        items: items
            .map(
              (item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildIndoorSwitch() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          const Icon(Icons.roofing_rounded, color: AppColors.primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Indoor Field',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          Switch(
            value: _isIndoor,
            onChanged: (v) => setState(() => _isIndoor = v),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Available Facilities',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableFacilities.map((facility) {
              final isSelected = _selectedFacilities.contains(facility);
              return FilterChip(
                label: Text(facility),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFacilities.add(facility);
                    } else {
                      _selectedFacilities.remove(facility);
                    }
                  });
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: AppShadows.small,
      ),
      child: _isLoadingCities
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading cities...'),
                ],
              ),
            )
          : DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: const InputDecoration(
                labelText: 'Select City',
                prefixIcon: Icon(Icons.location_city),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: _cities.map((city) {
                return DropdownMenuItem<String>(value: city, child: Text(city));
              }).toList(),
              onChanged: (v) => setState(() => _selectedCity = v),
              validator: (v) => v == null ? 'Please select a city' : null,
            ),
    );
  }

  Widget _buildSportCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: AppShadows.small,
      ),
      child: _isLoadingSportCategories
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading sport categories...'),
                ],
              ),
            )
          : DropdownButtonFormField<String>(
              value: _selectedSportCategory,
              decoration: const InputDecoration(
                labelText: 'Select Sport Category',
                prefixIcon: Icon(Icons.sports),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: _sportCategories.keys.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedSportCategory = v),
              validator: (v) =>
                  v == null ? 'Please select a sport category' : null,
            ),
    );
  }
}
