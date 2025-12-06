import 'package:flutter/material.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/super_admin/presentation/constants/admin_ui_constants.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_action_buttons.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_booking_history_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_profile_header.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_statistics_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/user_details/user_status_toggle_dialog.dart';

/// View widget for User Details.
///
/// Displays comprehensive user information including:
/// - Profile header
/// - Action buttons (activate/deactivate)
/// - Statistics section
/// - Booking history
class UserDetailsView extends StatefulWidget {
  final UserEntity user;

  const UserDetailsView({super.key, required this.user});

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  late UserEntity _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  void _handleStatusToggle() {
    showUserStatusToggleDialog(
      context: context,
      user: _currentUser,
      onStatusChanged: () {
        setState(() {
          _currentUser = _currentUser.copyWith(
            isActive: !_currentUser.isActive,
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AdminUIConstants.spacingXLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileHeader(user: _currentUser),
            const SizedBox(height: AdminUIConstants.spacingMedium),
            UserActionButtons(
              user: _currentUser,
              onToggleStatus: _handleStatusToggle,
            ),
            const SizedBox(height: AdminUIConstants.spacingLarge),
            UserStatisticsSection(user: _currentUser),
            const SizedBox(height: AdminUIConstants.spacingLarge),
            UserBookingHistorySection(user: _currentUser),
          ],
        ),
      ),
    );
  }
}
