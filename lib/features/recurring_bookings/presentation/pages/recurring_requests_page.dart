import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/recurring_requests_cubit.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/cubit/recurring_requests_state.dart';
import 'package:spo_kick/features/recurring_bookings/presentation/widgets/recurring_requests_content.dart';

/// Page for managing recurring booking requests (owner view).
class RecurringRequestsPage extends StatefulWidget {
  const RecurringRequestsPage({super.key});

  @override
  State<RecurringRequestsPage> createState() => _RecurringRequestsPageState();
}

class _RecurringRequestsPageState extends State<RecurringRequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RecurringRequestsCubit>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Recurring Subscriptions',
          style: TextStyle(
            color: AppColors.navyDeep,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            color: AppColors.accentCyan,
            onPressed: _handleRefresh,
          ),
        ],
      ),
      body: BlocConsumer<RecurringRequestsCubit, RecurringRequestsState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          return switch (state) {
            RecurringRequestsInitial() => const _LoadingView(),
            RecurringRequestsLoading() => const _LoadingView(),
            RecurringRequestsLoaded() => RecurringRequestsContent(
              state: state,
              onApprove: _handleApprove,
              onReject: _handleReject,
              onRefresh: _handleRefresh,
            ),
            RecurringRequestsError(:final message) => _ErrorView(
              message: message,
              onRetry: _handleRefresh,
            ),
          };
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, RecurringRequestsState state) {
    // Handle state changes if needed (e.g., showing success messages)
  }

  Future<void> _handleApprove(String requestId) async {
    final cubit = context.read<RecurringRequestsCubit>();
    final success = await cubit.approveRequest(requestId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Request approved! 4 weekly bookings have been created.'
                : 'Failed to approve request',
          ),
          backgroundColor: success ? const Color(0xFF10B981) : AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _handleReject(String requestId) async {
    final reason = await _showRejectDialog();
    if (reason == null) return;

    if (mounted) {
      final cubit = context.read<RecurringRequestsCubit>();
      final success = await cubit.rejectRequest(requestId, reason);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Request rejected' : 'Failed to reject request',
            ),
            backgroundColor: success
                ? AppColors.textSecondary
                : AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<String?> _showRejectDialog() async {
    final controller = TextEditingController();

    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.block_rounded, color: AppColors.error, size: 24),
            SizedBox(width: 12),
            Text('Reject Request'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please provide a reason for rejecting this recurring booking request:',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g., Slot not available, time conflict...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.accentCyan),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _handleRefresh() {
    context.read<RecurringRequestsCubit>().refresh();
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.accentCyan),
          SizedBox(height: 16),
          Text(
            'Loading requests...',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
