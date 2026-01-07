import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spo_kick/features/auth/presentation/cubit/admin_login_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spo_kick/features/auth/presentation/cubit/auth_state.dart';
import 'package:spo_kick/features/auth/presentation/widgets/admin_login/admin_login_scaffold.dart';
import 'package:spo_kick/features/auth/presentation/widgets/admin_login/admin_login_listener.dart';

/// Premium admin login view with navy gradient and gold accents
///
/// Stateless design - all state managed by cubits
class PremiumAdminLoginView extends StatelessWidget {
  const PremiumAdminLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminLoginCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) => AdminLoginListener.handle(context, state),
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return AdminLoginScaffold(isLoading: isLoading);
        },
      ),
    );
  }
}
