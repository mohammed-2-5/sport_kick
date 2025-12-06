import 'package:flutter/material.dart';
import 'package:spo_kick/features/settings/presentation/widgets/legal_page_widgets.dart';

/// Terms of Service Page
///
/// Displays the complete terms and conditions for using Sport Kick.
/// Covers user agreements, booking policies, and legal obligations.
class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  static const String _contactEmail = 'mohammedyasser2023@gmail.com';
  static const String _lastUpdated = 'December 1, 2025';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LegalPageHeader(
              icon: Icons.description,
              title: 'Terms of Service',
              description:
                  'Please read these terms carefully before using Sport Kick. '
                  'These terms govern your use of our platform and services.',
            ),
            SizedBox(height: 24),
            LegalSection(
              title: 'Acceptance of Terms',
              points: [
                'By using Sport Kick, you agree to these Terms of Service',
                'If you do not agree, please do not use our services',
                'We reserve the right to modify these terms at any time',
                'Continued use after changes constitutes acceptance',
              ],
            ),
            LegalSection(
              title: 'User Accounts',
              points: [
                'You must provide accurate and complete information when registering',
                'You are responsible for maintaining the security of your account',
                'You must be at least 13 years old to use our services',
                'One person or business per account',
                'You must not share your account credentials',
                'Notify us immediately of any unauthorized account access',
              ],
            ),
            LegalSection(
              title: 'Booking Policies',
              points: [
                'All bookings are subject to field availability',
                'Bookings may require owner approval before confirmation',
                'You must arrive on time for your booking',
                'Late arrivals may result in reduced playing time',
                'No-shows may result in account restrictions',
                'Prices are set by field owners and may vary',
              ],
            ),
            LegalSection(
              title: 'Cancellation and Refunds',
              points: [
                'Users can cancel bookings according to the cancellation policy',
                'Cancellations made 24+ hours in advance may be eligible for full refund',
                'Cancellations made less than 24 hours may incur fees',
                'No-shows are not eligible for refunds',
                'Refunds are processed according to payment method (3-7 business days)',
                'Field owners reserve the right to cancel bookings due to maintenance or weather',
              ],
            ),
            LegalSection(
              title: 'Payments',
              points: [
                'All payments are processed securely through our payment partners',
                'Prices are displayed in local currency (EGP)',
                'Payment is required to confirm booking (unless pay-at-venue is available)',
                'You authorize us to charge the payment method on file',
                'Disputed charges must be reported within 7 days',
                'We are not responsible for payment processing fees',
              ],
            ),
            LegalSection(
              title: 'User Conduct',
              points: [
                'You agree to use the app only for lawful purposes',
                'You must not abuse, harass, or harm other users or staff',
                'Respect field property and equipment',
                'Follow all field rules and safety guidelines',
                'Do not post false reviews or ratings',
                'Do not attempt to circumvent booking system',
              ],
            ),
            LegalSection(
              title: 'Field Owner Responsibilities',
              points: [
                'Provide accurate field information and availability',
                'Maintain field in safe and playable condition',
                'Honor confirmed bookings unless emergency arises',
                'Process booking approvals/rejections promptly',
                'Provide refunds according to cancellation policy',
                'Respond to user inquiries in a timely manner',
              ],
            ),
            LegalSection(
              title: 'Liability and Disclaimers',
              points: [
                'Sport Kick is a platform connecting users and field owners',
                'We are not responsible for the condition or safety of fields',
                'Users assume all risks associated with playing sports',
                'We recommend users have appropriate health/accident insurance',
                'Field owners are independent contractors, not our employees',
                'We are not liable for injuries, accidents, or losses at fields',
                'Maximum liability is limited to the amount paid for the booking',
              ],
            ),
            LegalSection(
              title: 'Intellectual Property',
              points: [
                'Sport Kick name, logo, and app design are our property',
                'You may not copy, modify, or distribute our content',
                'User-generated content (reviews, photos) may be used by us',
                'You retain ownership of content you upload',
                'You grant us license to use your content for promotional purposes',
              ],
            ),
            LegalSection(
              title: 'Termination',
              points: [
                'We reserve the right to suspend or terminate accounts',
                'Violations of these terms may result in immediate termination',
                'You can delete your account at any time',
                'Upon termination, you lose access to all bookings and data',
                'Outstanding payments remain due after termination',
              ],
            ),
            LegalSection(
              title: 'Dispute Resolution',
              points: [
                'Any disputes should first be reported to our support team',
                'We will attempt to resolve disputes amicably',
                'Unresolved disputes may be subject to arbitration',
                'Egyptian law governs these terms',
                'Jurisdiction is in Egyptian courts',
              ],
            ),
            LegalSection(
              title: 'Changes to Services',
              points: [
                'We may modify or discontinue features at any time',
                'We are not liable for any service modifications',
                'We will provide notice of significant changes when possible',
              ],
            ),
            SizedBox(height: 32),
            LegalContactSection(
              email: _contactEmail,
              description:
                  'If you have questions about these Terms of Service, please contact us:',
            ),
            SizedBox(height: 32),
            LegalLastUpdated(date: _lastUpdated),
          ],
        ),
      ),
    );
  }
}
