import 'package:dartz/dartz.dart';

import 'package:spo_kick/core/errors/failures.dart';
import 'package:spo_kick/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.resetPassword(email: email);
  }
}
