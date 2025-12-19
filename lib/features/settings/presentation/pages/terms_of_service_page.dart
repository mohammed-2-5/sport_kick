import 'package:flutter/material.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/settings/presentation/widgets/legal/legal_page_widgets.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Terms of Service Page
///
/// Displays the complete terms and conditions for using Sport Kick.
class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  static const String _contactEmail = 'mohammedyasser2023@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PremiumCurvedHeader(
            title: context.l10n.termsTitle,
            subtitle: context.l10n.termsSubtitle,
            showBackButton: true,
            height: 160,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LegalPageHeader(
                    icon: Icons.description,
                    title: context.l10n.termsTitle,
                    description: context.l10n.termsDescription,
                  ),
                  const SizedBox(height: 24),
                  LegalSection(
                    title: context.l10n.termsAcceptanceTitle,
                    points: [
                      context.l10n.termsAcceptanceAgree,
                      context.l10n.termsAcceptanceDisagree,
                      context.l10n.termsAcceptanceModify,
                      context.l10n.termsAcceptanceContinuedUse,
                    ],
                  ),
                  LegalSection(
                    title: context.l10n.termsAccountsTitle,
                    points: [
                      context.l10n.termsAccountsAccurateInfo,
                      context.l10n.termsAccountsSecurity,
                      context.l10n.termsAccountsAge,
                      context.l10n.termsAccountsSingle,
                      context.l10n.termsAccountsNoShare,
                      context.l10n.termsAccountsNotify,
                    ],
                  ),
                  LegalSection(
                    title: context.l10n.termsBookingTitle,
                    points: [
                      context.l10n.termsBookingAvailability,
                      context.l10n.termsBookingApproval,
                      context.l10n.termsBookingArrival,
                      context.l10n.termsBookingLate,
                      context.l10n.termsBookingNoShow,
                      context.l10n.termsBookingPrices,
                    ],
                  ),
                  LegalSection(
                    title: context.l10n.termsCancellationTitle,
                    points: [
                      context.l10n.termsCancellationPolicy,
                      context.l10n.termsCancellationFullRefund,
                      context.l10n.termsCancellationLateFees,
                      context.l10n.termsCancellationNoShow,
                      context.l10n.termsCancellationRefundTime,
                      context.l10n.termsCancellationOwnerCancel,
                    ],
                  ),
                  LegalSection(
                    title: context.l10n.termsConductTitle,
                    points: [
                      context.l10n.termsConductRules,
                      context.l10n.termsConductNoAbuse,
                      context.l10n.termsConductDamage,
                      context.l10n.termsConductProhibited,
                    ],
                  ),
                  LegalSection(
                    title: context.l10n.termsLiabilityTitle,
                    points: [
                      context.l10n.termsLiabilityPlatform,
                      context.l10n.termsLiabilityCondition,
                      context.l10n.termsLiabilityInjuries,
                      context.l10n.termsLiabilityOwner,
                    ],
                  ),
                  LegalSection(
                    title: context.l10n.termsPaymentsTitle,
                    points: [
                      context.l10n.termsPaymentsProcessed,
                      context.l10n.termsPaymentsFees,
                      context.l10n.termsPaymentsDisplay,
                      context.l10n.termsPaymentsRefunds,
                      context.l10n.termsPaymentsCurrency,
                    ],
                  ),
                  LegalSection(
                    title: context.l10n.termsIPTitle,
                    points: [
                      context.l10n.termsIPProtected,
                      context.l10n.termsIPBrand,
                      context.l10n.termsIPUserContent,
                    ],
                  ),
                  LegalSection(
                    title: context.l10n.termsTerminationTitle,
                    points: [
                      context.l10n.termsTerminationSuspend,
                      context.l10n.termsTerminationDelete,
                      context.l10n.termsTerminationDisputes,
                    ],
                  ),
                  LegalSection(
                    title: context.l10n.termsLawTitle,
                    points: [
                      context.l10n.termsLawGoverning,
                      context.l10n.termsLawDisputes,
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
}
