import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Premium profile header with curved design and avatar.
///
/// Features:
/// - Navy gradient curved header
/// - Overlapping avatar with camera button
/// - Glass effect on avatar border
/// - Edit profile button
class PremiumProfileHeader extends StatelessWidget {
  final String? avatarUrl;
  final String initials;
  final String name;
  final String? email;
  final VoidCallback? onBack;
  final VoidCallback? onEditAvatar;
  final VoidCallback? onEditProfile;

  const PremiumProfileHeader({
    super.key,
    this.avatarUrl,
    required this.initials,
    required this.name,
    this.email,
    this.onBack,
    this.onEditAvatar,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Curved header background
        Container(
          height: 220,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.navyDeep, AppColors.navyLight],
            ),
          ),
          child: Stack(
            children: [
              // Background decorations
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentCyan.withValues(alpha: 0.1),
                        AppColors.accentCyan.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Safe area content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      if (onBack != null)
                        GestureDetector(
                          onTap: onBack,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 40),

                      // Title
                      Text(
                        context.l10n.myProfile,
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      // Edit button
                      if (onEditProfile != null)
                        GestureDetector(
                          onTap: onEditProfile,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Curved bottom shape
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: _CurveClipper(),
            child: Container(height: 40, color: AppColors.lightBackground),
          ),
        ),

        // Avatar
        Positioned(
          bottom: -50,
          left: 0,
          right: 0,
          child: Center(
            child: _ProfileAvatar(
              avatarUrl: avatarUrl,
              initials: initials,
              onEdit: onEditAvatar,
            ),
          ),
        ),
      ],
    );
  }
}

/// Profile avatar with edit button.
class _ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String initials;
  final VoidCallback? onEdit;

  const _ProfileAvatar({
    required this.avatarUrl,
    required this.initials,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Avatar with glass border
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.accentCyan, AppColors.accentCyanDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentCyan.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: ClipOval(
              child: avatarUrl != null
                  ? CachedNetworkImage(
                      imageUrl: avatarUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          _InitialsAvatar(initials: initials),
                      errorWidget: (context, url, error) =>
                          _InitialsAvatar(initials: initials),
                    )
                  : _InitialsAvatar(initials: initials),
            ),
          ),
        ),

        // Camera button
        if (onEdit != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.accentCyan, AppColors.accentCyanDark],
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Initials avatar.
class _InitialsAvatar extends StatelessWidget {
  final String initials;

  const _InitialsAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navyDeep, AppColors.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.displaySmall.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Curve clipper for bottom shape.
class _CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Profile info section below header.
class PremiumProfileInfo extends StatelessWidget {
  final String name;
  final String? email;
  final String? phone;
  final String? memberSince;

  const PremiumProfileInfo({
    super.key,
    required this.name,
    this.email,
    this.phone,
    this.memberSince,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name
        Text(
          name,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),

        if (email != null) ...[
          const SizedBox(height: 4),
          Text(
            email!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],

        if (memberSince != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: AppColors.accentCyan,
                ),
                const SizedBox(width: 6),
                Text(
                  context.l10n.memberSinceDate(memberSince!),
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentCyan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
