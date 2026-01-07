part of 'admin_login_cubit.dart';

/// State for Admin Login Screen
class AdminLoginState extends Equatable {
  final bool isPasswordVisible;

  const AdminLoginState({this.isPasswordVisible = false});

  AdminLoginState copyWith({bool? isPasswordVisible}) {
    return AdminLoginState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [isPasswordVisible];
}
