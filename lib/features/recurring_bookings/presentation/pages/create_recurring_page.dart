import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/features/business_hours/domain/repositories/business_hours_repository.dart';
import 'package:spo_kick/features/business_hours/domain/entities/business_hours_entity.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/create_recurring_request_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/domain/usecases/get_reserved_slots_usecase.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/create_recurring_cubit.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/create_recurring_state.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/create_recurring_content.dart';
import 'package:spo_kick/l10n/l10n_extensions.dart';

/// Page for creating a new recurring booking request.
class CreateRecurringPage extends StatefulWidget {
  final FieldEntity field;

  const CreateRecurringPage({required this.field, super.key});

  @override
  State<CreateRecurringPage> createState() => _CreateRecurringPageState();
}

class _CreateRecurringPageState extends State<CreateRecurringPage> {
  List<BusinessHoursEntity> _businessHours = [];
  bool _isLoadingHours = true;

  @override
  void initState() {
    super.initState();
    _loadBusinessHours();
  }

  Future<void> _loadBusinessHours() async {
    final repository = sl<BusinessHoursRepository>();
    final result = await repository.getFieldBusinessHours(widget.field.id);

    if (mounted) {
      setState(() {
        _isLoadingHours = false;
        result.fold(
          (failure) => _businessHours = [],
          (hours) => _businessHours = hours,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateRecurringCubit(
        createRecurringRequestUseCase: sl<CreateRecurringRequestUseCase>(),
        getReservedSlotsUseCase: sl<GetReservedSlotsUseCase>(),
        field: widget.field,
      ),
      child: Builder(
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          return Scaffold(
            backgroundColor: colorScheme.surface,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                color: colorScheme.onSurface,
                onPressed: () => context.pop(),
              ),
              title: Text(
                context.l10n.reserveWeeklySlot,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: _isLoadingHours
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accentCyan,
                    ),
                  )
                : BlocConsumer<CreateRecurringCubit, CreateRecurringState>(
                    listener: _handleStateChanges,
                    builder: (context, state) {
                      return CreateRecurringContent(
                        state: state,
                        businessHours: _businessHours,
                        onDaySelected: context
                            .read<CreateRecurringCubit>()
                            .selectDayOfWeek,
                        onTimeSelected: context
                            .read<CreateRecurringCubit>()
                            .selectTime,
                        onDurationChanged: context
                            .read<CreateRecurringCubit>()
                            .setDuration,
                        onSubmit: context.read<CreateRecurringCubit>().submit,
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, CreateRecurringState state) {
    if (state is CreateRecurringSuccess) {
      _showSuccessDialog();
    } else if (state is CreateRecurringError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      context.read<CreateRecurringCubit>().resetAfterError();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                final successColor = isDark
                    ? AppColors.darkSuccess
                    : AppColors.success;
                final colorScheme = Theme.of(context).colorScheme;
                return Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: successColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        size: 48,
                        color: successColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.l10n.recurringRequestSubmittedTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.recurringRequestSubmittedBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  context.go('/myRecurringBookings'); // Navigate to list
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentCyan,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  context.l10n.viewMySubscriptions,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
