import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/auth/presentation/widgets/profile/initials_avatar.dart';
import 'package:spo_kick/features/home/presentation/widgets/curved_header_clipper.dart';

/// Profile page header with curved background and avatar.
///
/// Displays the user's avatar (or initials) overlapping a curved header.
class ProfileHeader extends StatelessWidget {
  final String? avatarUrl;
  final String initials;
  final VoidCallback onBackPressed;

  const ProfileHeader({
    required this.avatarUrl,
    required this.initials,
    required this.onBackPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Curved Header Background
        ClipPath(
          clipper: CurvedHeaderClipper(),
          child: Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1F3A), // Deep Navy
                  Color(0xFF2C3E50), // Lighter Navy
                ],
              ),
            ),
          ),
        ),

        // Header Content (Title)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: onBackPressed,
                  ),
                  const Expanded(
                    child: Text(
                      'My Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance back button
                ],
              ),
            ),
          ),
        ),

        // Overlapping Avatar
        Positioned(
          bottom: -50,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.lightBackground,
              child: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        avatarUrl!,
                        width: 112,
                        height: 112,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return InitialsAvatar(initials: initials);
                        },
                      ),
                    )
                  : InitialsAvatar(initials: initials),
            ),
          ),
        ),
      ],
    );
  }
}
