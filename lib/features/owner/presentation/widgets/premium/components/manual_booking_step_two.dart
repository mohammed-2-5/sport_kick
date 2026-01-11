import 'package:flutter/material.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_form_field.dart';
import 'package:spo_kick/features/owner/presentation/widgets/premium/premium_form_section.dart';
import 'package:spo_kick/l10n/app_localizations.dart';

class ManualBookingStepTwo extends StatelessWidget {
  final AppLocalizations l10n;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController notesController;

  const ManualBookingStepTwo({
    super.key,
    required this.l10n,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            PremiumFormSection(
              title: l10n.customerInfoTitle,
              icon: Icons.person,
              children: [
                PremiumFormField(
                  label: l10n.customerNameLabel,
                  hintText: l10n.enterCustomerNameHint,
                  controller: nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.customerNameRequired;
                    }
                    return null;
                  },
                ),
                PremiumFormField(
                  label: l10n.phoneLabel,
                  hintText: l10n.enterPhoneHint,
                  controller: phoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.phoneRequired;
                    }
                    return null;
                  },
                ),
                PremiumFormField(
                  label: l10n.emailOptionalLabel,
                  hintText: l10n.enterEmailHint,
                  controller: emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                PremiumFormField(
                  label: l10n.notesOptionalLabel,
                  hintText: l10n.addNotesHint,
                  controller: notesController,
                  prefixIcon: Icons.notes,
                  maxLines: 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
