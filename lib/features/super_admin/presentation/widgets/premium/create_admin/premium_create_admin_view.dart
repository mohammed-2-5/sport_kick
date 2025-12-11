import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_form/admin_form_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/admin_form/admin_form_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/create_admin/premium_admin_form_buttons.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/create_admin/premium_admin_form_field.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/create_admin/premium_admin_form_info_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/create_admin/premium_admin_success_overlay.dart';

/// Premium create admin view.
///
/// Features:
/// - Premium curved header with gold theme
/// - Form with real-time validation
/// - Success overlay with credentials
/// - All UI logic handled by AdminFormCubit
class PremiumCreateAdminView extends StatelessWidget {
  const PremiumCreateAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminFormCubit, AdminFormState>(
      listener: (context, state) {
        if (state is AdminFormError) {
          SnackbarHelper.showError(context, state.message);
          context.read<AdminFormCubit>().restoreFromError();
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.backgroundLight,
              body: CustomScrollView(
                slivers: [
                  // Premium Header
                  const SliverToBoxAdapter(
                    child: PremiumCurvedHeader(
                      title: 'Create Admin',
                      subtitle: 'Add a new field owner',
                      showBackButton: true,
                    ),
                  ),

                  // Form Content
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const PremiumAdminFormInfoCard(),
                        const SizedBox(height: 24),
                        _FormFieldsSection(state: state),
                        const SizedBox(height: 32),
                        _FormButtonsSection(state: state),
                        const SizedBox(height: 32),
                      ]),
                    ),
                  ),
                ],
              ),
            ),

            // Success Overlay
            if (state is AdminFormSuccess)
              PremiumAdminSuccessOverlay(
                invitation: state.invitation,
                onDone: () => context.pop(),
              ),
          ],
        );
      },
    );
  }
}

/// Form fields section widget.
class _FormFieldsSection extends StatelessWidget {
  final AdminFormState state;

  const _FormFieldsSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminFormCubit>();

    String? emailError;
    String? nameError;
    String? phoneError;

    if (state is AdminFormData) {
      final formData = state as AdminFormData;
      emailError = formData.emailError;
      nameError = formData.nameError;
      phoneError = formData.phoneError;
    }

    final isSubmitting = state is AdminFormSubmitting;

    return AbsorbPointer(
      absorbing: isSubmitting,
      child: Opacity(
        opacity: isSubmitting ? 0.6 : 1.0,
        child: Column(
          children: [
            PremiumAdminFormField(
              label: 'Email Address',
              hint: 'admin@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
              errorText: emailError,
              onChanged: cubit.updateEmail,
            ),
            const SizedBox(height: 20),
            PremiumAdminFormField(
              label: 'Full Name',
              hint: 'Ahmed Mohamed',
              icon: Icons.person_outline,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              isRequired: true,
              errorText: nameError,
              onChanged: cubit.updateFullName,
            ),
            const SizedBox(height: 20),
            PremiumAdminFormField(
              label: 'Phone Number',
              hint: '+20 123 456 7890',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              errorText: phoneError,
              onChanged: cubit.updatePhone,
            ),
          ],
        ),
      ),
    );
  }
}

/// Form buttons section widget.
class _FormButtonsSection extends StatelessWidget {
  final AdminFormState state;

  const _FormButtonsSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminFormCubit>();

    final isSubmitting = state is AdminFormSubmitting;
    final isValid = state is AdminFormData && (state as AdminFormData).isValid;

    return PremiumAdminFormButtons(
      isSubmitting: isSubmitting,
      isValid: isValid,
      onSubmit: cubit.submit,
      onCancel: () => context.pop(),
    );
  }
}
