import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/features/owner/presentation/widgets/settings/switch_tile.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Booking preferences section widget for owner settings page.
class OwnerBookingSection extends StatelessWidget {
  final bool autoApproveBookings;
  final ValueChanged<bool> onAutoApproveChanged;

  const OwnerBookingSection({
    super.key,
    required this.autoApproveBookings,
    required this.onAutoApproveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.l10n.bookingPreferencesSection,
      icon: Icons.settings_outlined,
      children: [
        SwitchTile(
          icon: Icons.check_circle_outline,
          iconColor: AppColors.success,
          title: context.l10n.autoApproveBookings,
          subtitle: context.l10n.autoApproveBookingsDesc,
          value: autoApproveBookings,
          onChanged: (value) {
            onAutoApproveChanged(value);
            _showAutoApproveDialog(context, value);
          },
        ),
        const SizedBox(height: 8),
        SettingsTile(
          leading: const Icon(Icons.schedule, color: AppColors.info),
          title: context.l10n.businessHours,
          subtitle: context.l10n.setWorkingHoursDesc,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showBusinessHoursDialog(context),
        ),
      ],
    );
  }

  void _showAutoApproveDialog(BuildContext context, bool enabled) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          enabled
              ? context.l10n.autoApproveEnabledTitle
              : context.l10n.autoApproveDisabledTitle,
        ),
        content: Text(
          enabled
              ? context.l10n.autoApproveEnabledMessage
              : context.l10n.autoApproveDisabledMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showBusinessHoursDialog(BuildContext context) {
    // Get current user's owner ID
    final authState = context.read<AuthCubit>().state;
    if (authState is! Authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.pleaseLoginToManageBusinessHours),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final ownerId = authState.user.id;

    // Show field selection dialog
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider(
        create: (_) => sl<OwnerCubit>()..loadOwnerFields(ownerId),
        child: _FieldSelectionDialog(
          onFieldSelected: (fieldId, fieldName) {
            Navigator.pop(dialogContext);
            context.go(
              '/owner/fields/$fieldId/business-hours',
              extra: {'fieldName': fieldName},
            );
          },
        ),
      ),
    );
  }
}

/// Field selection dialog for choosing which field to manage business hours for.
class _FieldSelectionDialog extends StatelessWidget {
  final void Function(String fieldId, String fieldName) onFieldSelected;

  const _FieldSelectionDialog({required this.onFieldSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.selectField),
      content: BlocBuilder<OwnerCubit, OwnerState>(
        builder: (context, state) {
          if (state is OwnerLoading) {
            return const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is OwnerError) {
            return SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  state.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            );
          }

          if (state is OwnerFieldsLoaded) {
            if (state.fields.isEmpty) {
              return SizedBox(
                height: 100,
                child: Center(child: Text(context.l10n.youHaveNoFields)),
              );
            }

            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.fields.length,
                itemBuilder: (context, index) {
                  final field = state.fields[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.sports_soccer,
                      color: AppColors.primary,
                    ),
                    title: Text(field.name),
                    subtitle: Text(field.address),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => onFieldSelected(field.id, field.name),
                  );
                },
              ),
            );
          }

          return SizedBox(
            height: 100,
            child: Center(child: Text(context.l10n.loadingFields)),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
      ],
    );
  }
}
