import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_text_styles.dart';
import 'package:spo_kick/core/di/injection_container.dart';
import 'package:spo_kick/core/widgets/premium/premium_curved_header.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/sport_categories_cubit.dart';
import 'package:spo_kick/features/super_admin/presentation/cubit/sport_categories_state.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/sport_categories/premium_sport_category_card.dart';
import 'package:spo_kick/features/super_admin/presentation/widgets/premium/sport_categories/sport_category_form_dialog.dart';
import 'package:spo_kick/core/localization/l10n_extensions.dart';

/// Sport categories management page for super admin.
///
/// Features:
/// - View all sport categories
/// - Create new categories
/// - Edit existing categories
/// - Delete categories
class ManageSportCategoriesPage extends StatelessWidget {
  const ManageSportCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SportCategoriesCubit>()..loadCategories(),
      child: const _ManageSportCategoriesView(),
    );
  }
}

class _ManageSportCategoriesView extends StatelessWidget {
  const _ManageSportCategoriesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocConsumer<SportCategoriesCubit, SportCategoriesState>(
        listener: (context, state) {
          if (state is SportCategoryOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
            // Reload after showing success message
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!context.mounted) return;
              context.read<SportCategoriesCubit>().loadCategories();
            });
          } else if (state is SportCategoriesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: PremiumCurvedHeader(
                  title: context.l10n.sportCategories,
                  subtitle: context.l10n.manageSportTypes,
                  showBackButton: true,
                  actions: [
                    _AddButton(onTap: () => _showCreateDialog(context)),
                  ],
                ),
              ),

              if (state is SportCategoriesLoading)
                const SliverFillRemaining(child: _LoadingView())
              else if (state is SportCategoriesError)
                SliverFillRemaining(
                  child: _ErrorView(
                    message: state.message,
                    onRetry: () =>
                        context.read<SportCategoriesCubit>().loadCategories(),
                  ),
                )
              else if (state is SportCategoriesLoaded ||
                  state is SportCategoryOperationSuccess)
                _buildContent(context, state)
              else
                const SliverFillRemaining(child: _LoadingView()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, SportCategoriesState state) {
    final categories = state is SportCategoriesLoaded
        ? state.categories
        : (state as SportCategoryOperationSuccess).updatedCategories;

    if (categories.isEmpty) {
      return const SliverFillRemaining(child: _EmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final category = categories[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(
                child: PremiumSportCategoryCard(
                  category: category,
                  onEdit: () => _showEditDialog(context, category),
                  onDelete: () => _showDeleteDialog(context, category),
                ),
              ),
            ),
          );
        }, childCount: categories.length),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    SportCategoryFormDialog.show(
      context,
      onSubmit: (name, icon, description) {
        context.read<SportCategoriesCubit>().createCategory(
          name: name,
          icon: icon,
          description: description,
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, category) {
    SportCategoryFormDialog.show(
      context,
      category: category,
      onSubmit: (name, icon, description) {
        context.read<SportCategoriesCubit>().updateCategory(
          categoryId: category.id,
          name: name,
          icon: icon,
          description: description,
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, category) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.deleteCategory),
        content: Text(context.l10n.deleteCategoryConfirmation(category.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SportCategoriesCubit>().deleteCategory(
                categoryId: category.id,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassHighlight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.add_rounded,
          color: AppColors.textOnNavy,
          size: 22,
        ),
        onPressed: onTap,
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.goldAccent,
        strokeWidth: 3,
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.failedToLoadCategories,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.tryAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navyDeep,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.goldAccent.withValues(alpha: 0.2),
                    AppColors.goldAccent.withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sports_rounded,
                size: 48,
                color: AppColors.goldAccent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.noCategoriesYet,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.tapTheButtonToCreateNyour,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
