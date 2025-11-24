import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/entities/user_entity.dart';
import 'package:spo_kick/features/auth/domain/repositories/auth_repository.dart';

/// Use case for registering a new user.
///
/// Handles the business logic for user registration.
class RegisterUseCase {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  /// Executes the register use case.
  ///
  /// Returns [UserEntity] on successful registration or [Failure] on error.
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
      phone: params.phone,
    );
  }
}

/// Parameters for the Register use case.
class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String fullName;
  final String? phone;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.fullName,
    this.phone,
  });

  @override
  List<Object?> get props => [email, password, fullName, phone];
}
