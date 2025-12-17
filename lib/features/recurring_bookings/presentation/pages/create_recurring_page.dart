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
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: AppColors.navyDeep,
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Reserve Weekly Slot',
            style: TextStyle(
              color: AppColors.navyDeep,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _isLoadingHours
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.accentCyan),
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 48,
                color: Color(0xFF10B981),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Request Submitted!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.navyDeep,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your recurring booking request has been sent to the field owner. '
              'You\'ll be notified once it\'s approved.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
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
                child: const Text(
                  'View My Subscriptions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
