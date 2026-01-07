import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/utils/snackbar_helper.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/super_admin/domain/entities/platform_settings_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/platform_settings/platform_settings_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/platform_settings/platform_settings_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/operating_hours/operating_hours_day_item.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/operating_hours/operating_hours_quick_actions.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Platform Operating Hours Page
///
/// Allows super admin to configure default operating hours
/// for all new fields on the platform.
class PlatformOperatingHoursPage extends StatelessWidget {
  const PlatformOperatingHoursPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PlatformSettingsCubit>()..loadSettings(),
      child: const _OperatingHoursContent(),
    );
  }
}

/// Operating hours page content.
class _OperatingHoursContent extends StatelessWidget {
  const _OperatingHoursContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlatformSettingsCubit, PlatformSettingsState>(
      listener: (context, state) {
        if (state is PlatformSettingsLoaded && state.successMessage != null) {
          SnackbarHelper.showSuccess(context, state.successMessage!);
        }
        if (state is PlatformSettingsError) {
          SnackbarHelper.showError(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: PremiumCurvedHeader(
                  title: context.l10n.operatingHours,
                  subtitle: context.l10n.defaultHoursForNewFields,
                  showBackButton: true,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: _buildContent(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, PlatformSettingsState state) {
    if (state is PlatformSettingsLoading) {
      return SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      );
    }

    if (state is PlatformSettingsError) {
      return SliverFillRemaining(
        child: _ErrorState(
          message: state.message,
          onRetry: () => context.read<PlatformSettingsCubit>().loadSettings(),
        ),
      );
    }

    if (state is PlatformSettingsLoaded) {
      return _LoadedContent(state: state);
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}

/// Loaded content widget.
class _LoadedContent extends StatelessWidget {
  final PlatformSettingsLoaded state;

  const _LoadedContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlatformSettingsCubit>();
    final settings = state.settings;

    return SliverList(
      delegate: SliverChildListDelegate([
        // Enforce toggle
        _EnforceToggle(
          enforceHours: settings.enforceOperatingHours,
          onToggle: () => cubit.toggleEnforceHours(),
        ),
        const SizedBox(height: 20),

        // Quick actions
        OperatingHoursQuickActions(
          currentHours: settings.getHoursForDay(DayOfWeek.monday),
          onApplyToWeekdays: () => cubit.applyToAllWeekdays(
            settings.getHoursForDay(DayOfWeek.monday),
          ),
          onApplyToWeekend: () =>
              cubit.applyToWeekend(settings.getHoursForDay(DayOfWeek.saturday)),
        ),
        const SizedBox(height: 24),

        // Section header
        _SectionHeader(title: context.l10n.weeklySchedule),
        const SizedBox(height: 12),

        // Days list
        ...DayOfWeek.values.map((day) {
          final hours = settings.getHoursForDay(day);
          return OperatingHoursDayItem(
            day: day,
            hours: hours,
            onToggleOpen: (_) => cubit.toggleDayOpen(day),
            onOpenTimeChanged: (time) => cubit.updateOpenTime(day, time),
            onCloseTimeChanged: (time) => cubit.updateCloseTime(day, time),
          );
        }),

        // Saving indicator
        if (state.isSaving) ...[
          const SizedBox(height: 16),
          const _SavingIndicator(),
        ],

        const SizedBox(height: 32),
      ]),
    );
  }
}

/// Enforce toggle widget.
class _EnforceToggle extends StatelessWidget {
  final bool enforceHours;
  final VoidCallback onToggle;

  const _EnforceToggle({required this.enforceHours, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.schedule, color: colorScheme.secondary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.enforceOperatingHours,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  context.l10n.applyToAllFieldBookings,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enforceHours,
            onChanged: (_) => onToggle(),
            activeTrackColor: colorScheme.primary.withValues(alpha: 0.5),
            activeThumbColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

/// Section header widget.
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

/// Saving indicator widget.
class _SavingIndicator extends StatelessWidget {
  const _SavingIndicator();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.tertiary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          context.l10n.saving,
          style: AppTextStyles.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Error state widget.
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
