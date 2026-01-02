import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_section.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/settings/settings_tile.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Account section widget for super admin settings page.
/// Displays user profile information with edit options.
class SuperAdminAccountSection extends StatelessWidget {
  const SuperAdminAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.user;

          return SettingsSection(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user.initials,
                    style: AppTextStyles.titleMediumWhite,
                  ),
                ),
                title: Text(
                  user.fullName ?? user.email,
                  style: AppTextStyles.bold(AppTextStyles.bodyLarge),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.email),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        context.l10n.roleSuperAdmin,
                        style: AppTextStyles.withColor(
                          AppTextStyles.labelSmallBold,
                          Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => context.pushNamed('editProfile'),
                ),
              ),
              const Divider(height: 1),
              SettingsTile(
                icon: Icons.phone,
                title: context.l10n.phone2,
                subtitle: user.phone ?? context.l10n.notSet,
                onTap: () => context.pushNamed('editProfile'),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
