import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/repositories/auth_repository.dart';

/// Use case for logging in a user.
///
/// Handles the business logic for user authentication.
class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  /// Executes the login use case.
  ///
  /// Returns [UserEntity] on successful login or [Failure] on error.
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for the Login use case.
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
