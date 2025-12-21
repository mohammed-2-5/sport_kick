import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/super_admin_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_admin/admin_form_info_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/create_admin/admin_success_dialog.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Create Admin View - Form for creating new admin accounts.
///
/// Displays:
/// - Info card explaining the process
/// - Email, name, and phone form fields
/// - Create and cancel buttons
class CreateAdminView extends StatefulWidget {
  const CreateAdminView({super.key});

  @override
  State<CreateAdminView> createState() => _CreateAdminViewState();
}

class _CreateAdminViewState extends State<CreateAdminView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleCreateAdmin() {
    if (_formKey.currentState!.validate()) {
      context.read<SuperAdminCubit>().createAdmin(
        email: _emailController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      );
    }
  }

  void _showSuccessDialog(AdminAccountCreated state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AdminSuccessDialog(
        invitation: state.invitation,
        onDone: () {
          Navigator.of(dialogContext).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.createAdminAccount),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<SuperAdminCubit, SuperAdminState>(
        listener: (context, state) {
          if (state is SuperAdminLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is SuperAdminError) {
            SnackbarHelper.showError(context, state.message);
          }

          if (state is AdminAccountCreated) {
            _showSuccessDialog(state);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AdminFormInfoCard(),
                  const SizedBox(height: 24),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: context.l10n.emailAddressRequired,
                      hintText: context.l10n.adminExampleCom,
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.l10n.emailIsRequired;
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return context.l10n.pleaseEnterAValidEmail;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Full Name Field
                  TextFormField(
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: context.l10n.fullNameRequired,
                      hintText: context.l10n.ahmedMohamed,
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.l10n.nameIsRequired;
                      }
                      if (value.trim().length < 3) {
                        return context.l10n.nameMustBeAtLeast3Characters;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Phone Field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: context.l10n.phoneNumberOptional,
                      hintText: context.l10n.phoneExample,
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
                        if (!phoneRegex.hasMatch(value.trim())) {
                          return context.l10n.pleaseEnterAValidPhoneNumber;
                        }
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Create Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleCreateAdmin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            context.l10n.createAdminAccount,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),

                  const SizedBox(height: 16),

                  // Cancel Button
                  OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(context.l10n.cancel),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
