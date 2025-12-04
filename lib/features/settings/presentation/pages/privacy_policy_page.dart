import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';

/// Privacy Policy Page
///
/// Displays the complete privacy policy for Sport Kick application.
/// Covers data collection, usage, storage, and user rights.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildSection(context, 'Information We Collect', [
              'Account information (name, email, phone number)',
              'Profile information you provide',
              'Booking history and preferences',
              'Location data when using the app',
              'Device information and usage data',
              'Payment information (processed securely by our payment provider)',
            ]),
            _buildSection(context, 'How We Use Your Information', [
              'To provide and maintain our booking services',
              'To process your bookings and payments',
              'To communicate with you about bookings and updates',
              'To improve our services and user experience',
              'To prevent fraud and ensure security',
              'To comply with legal obligations',
            ]),
            _buildSection(context, 'Data Storage and Security', [
              'Your data is stored securely using Supabase (PostgreSQL database)',
              'We use industry-standard encryption for data transmission',
              'Payment information is handled by certified payment processors',
              'We implement regular security updates and monitoring',
              'Access to personal data is restricted to authorized personnel only',
            ]),
            _buildSection(context, 'Data Sharing', [
              'We do NOT sell your personal information to third parties',
              'Field owners can see your booking details (name, phone) for confirmed bookings',
              'We may share data with service providers (payment processors, analytics)',
              'We will share data if required by law or to protect rights and safety',
            ]),
            _buildSection(context, 'Your Rights', [
              'Access your personal data at any time through your profile',
              'Update or correct your information',
              'Delete your account and associated data',
              'Opt-out of marketing communications',
              'Export your booking history',
              'Withdraw consent for data processing (may limit service availability)',
            ]),
            _buildSection(context, 'Cookies and Tracking', [
              'We use cookies and similar technologies to improve user experience',
              'Analytics cookies help us understand app usage',
              'You can disable cookies in your device settings',
              'Some features may not work without cookies',
            ]),
            _buildSection(context, 'Children\'s Privacy', [
              'Our service is not intended for children under 13',
              'We do not knowingly collect data from children',
              'If we learn we have collected child data, we will delete it',
              'Parents can contact us to request data deletion',
            ]),
            _buildSection(context, 'Changes to This Policy', [
              'We may update this privacy policy from time to time',
              'We will notify you of significant changes via email or app notification',
              'Continued use of the app after changes constitutes acceptance',
              'Last updated: December 1, 2025',
            ]),
            const SizedBox(height: 32),
            _buildContactSection(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.privacy_tip, color: AppColors.primary, size: 32),
              const SizedBox(width: 12),
              Text(
                'Your Privacy Matters',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Sport Kick is committed to protecting your privacy and personal information. '
            'This policy explains how we collect, use, and safeguard your data.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Effective Date: December 1, 2025',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<String> points,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    point,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.contact_support,
                color: AppColors.info,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Contact Us',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'If you have questions about this Privacy Policy or how we handle your data, please contact us:',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.email, size: 16, color: AppColors.info),
              const SizedBox(width: 8),
              Text(
                'mohammedyasser2023@gmail.com',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
