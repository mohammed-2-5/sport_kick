import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/settings/presentation/widgets/legal/legal_page_widgets.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Privacy Policy Page
///
/// Displays the complete privacy policy for Sport Kick application.
/// Covers data collection, usage, storage, and user rights.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const String _contactEmail = 'mohammedyasser2023@gmail.com';
  static const String _effectiveDate = 'December 1, 2025';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PremiumCurvedHeader(
            title: context.l10n.privacyPolicyTitle,
            subtitle: context.l10n.privacyPolicySubtitle,
            showBackButton: true,
            height: 160,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrivacyHeader(context),
                  const SizedBox(height: 24),
                  _PrivacySection(
                    title: context.l10n.privacyInfoCollectTitle,
                    points: [
                      context.l10n.privacyCollectAccountInfo,
                      context.l10n.privacyCollectProfileInfo,
                      context.l10n.privacyCollectBookingHistory,
                      context.l10n.privacyCollectLocation,
                      context.l10n.privacyCollectDevice,
                      context.l10n.privacyCollectPayment,
                    ],
                  ),
                  _PrivacySection(
                    title: context.l10n.privacyUseInfoTitle,
                    points: [
                      context.l10n.privacyUseProvideService,
                      context.l10n.privacyUseProcessPayments,
                      context.l10n.privacyUseCommunicate,
                      context.l10n.privacyUseImprove,
                      context.l10n.privacyUseSecurity,
                      context.l10n.privacyUseLegal,
                    ],
                  ),
                  _PrivacySection(
                    title: context.l10n.privacyStorageTitle,
                    points: [
                      context.l10n.privacyStorageSecure,
                      context.l10n.privacyStorageEncryption,
                      context.l10n.privacyStoragePayment,
                      context.l10n.privacyStorageUpdates,
                      context.l10n.privacyStorageAccess,
                    ],
                  ),
                  _PrivacySection(
                    title: context.l10n.privacySharingTitle,
                    points: [
                      context.l10n.privacySharingNoSell,
                      context.l10n.privacySharingOwners,
                      context.l10n.privacySharingProviders,
                      context.l10n.privacySharingLegal,
                    ],
                  ),
                  _PrivacySection(
                    title: context.l10n.privacyRightsTitle,
                    points: [
                      context.l10n.privacyRightsAccess,
                      context.l10n.privacyRightsUpdate,
                      context.l10n.privacyRightsDelete,
                      context.l10n.privacyRightsOptOut,
                      context.l10n.privacyRightsExport,
                      context.l10n.privacyRightsWithdraw,
                    ],
                  ),
                  _PrivacySection(
                    title: context.l10n.privacyCookiesTitle,
                    points: [
                      context.l10n.privacyCookiesUse,
                      context.l10n.privacyCookiesAnalytics,
                      context.l10n.privacyCookiesDisable,
                      context.l10n.privacyCookiesImpact,
                    ],
                  ),
                  _PrivacySection(
                    title: context.l10n.privacyChildrenTitle,
                    points: [
                      context.l10n.privacyChildrenNotFor,
                      context.l10n.privacyChildrenNoCollect,
                      context.l10n.privacyChildrenDelete,
                      context.l10n.privacyChildrenParents,
                    ],
                  ),
                  _PrivacySection(
                    title: context.l10n.privacyChangesTitle,
                    points: [
                      context.l10n.privacyChangesMayUpdate,
                      context.l10n.privacyChangesNotify,
                      context.l10n.privacyChangesAccept,
                      context.l10n.privacyChangesLastUpdated(_effectiveDate),
                    ],
                  ),
                  const SizedBox(height: 32),
                  LegalContactSection(
                    email: _contactEmail,
                    title: context.l10n.supportContactTitle,
                    description: context.l10n.supportContactDescription,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyHeader(BuildContext context) {
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
              const Icon(Icons.privacy_tip, color: AppColors.primary, size: 32),
              const SizedBox(width: 12),
              Text(
                context.l10n.privacyHeaderTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.privacyHeaderDescription,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Effective Date: $_effectiveDate',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Privacy section with check icon (different from LegalSection which uses bullet).
class _PrivacySection extends StatelessWidget {
  final String title;
  final List<String> points;

  const _PrivacySection({required this.title, required this.points});

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.only(top: 2),
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
}
