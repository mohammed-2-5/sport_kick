import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/core/constants/app_gradients.dart';
import 'package:spo_kick/core/widgets/loading_indicator.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:spo_kick/features/owner/presentation/cubit/owner_state.dart';
import 'package:spo_kick/features/owner/presentation/utils/delete_field_confirmation_dialog.dart';
import 'package:spo_kick/features/owner/presentation/widgets/owner_field_card.dart';
import 'package:spo_kick/features/owner/presentation/widgets/owner_fields_empty_state.dart';

/// Owner Fields Management Page
///
/// Allows owners to:
/// - View all their fields
/// - Add new fields
/// - Edit existing fields
/// - Delete fields
class OwnerFieldsPage extends StatefulWidget {
  const OwnerFieldsPage({super.key});

  @override
  State<OwnerFieldsPage> createState() => _OwnerFieldsPageState();
}

class _OwnerFieldsPageState extends State<OwnerFieldsPage> {
  @override
  void initState() {
    super.initState();
    _loadFields();
  }

  void _loadFields() {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<OwnerCubit>().loadOwnerFields(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Fields'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppGradients.primary),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('ownerAddField'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Field',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<OwnerCubit, OwnerState>(
        builder: (context, state) {
          if (state is OwnerLoading) {
            return const LoadingIndicator.inline(message: 'Loading fields...');
          }

          if (state is OwnerDataLoaded || state is OwnerFieldsLoaded) {
            final fields = state is OwnerDataLoaded
                ? state.fields
                : (state as OwnerFieldsLoaded).fields;

            if (fields.isEmpty) {
              return const OwnerFieldsEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async => _loadFields(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: fields.length,
                itemBuilder: (context, index) {
                  final field = fields[index];
                  return OwnerFieldCard(
                    field: field,
                    onEdit: () =>
                        context.pushNamed('ownerEditField', extra: field),
                    onDelete: () => showDeleteFieldConfirmation(
                      context: context,
                      field: field,
                    ),
                  );
                },
              ),
            );
          }

          if (state is OwnerError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _loadFields,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const OwnerFieldsEmptyState();
        },
      ),
    );
  }
}
