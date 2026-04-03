import 'package:habitbot/core/error/failures.dart';
import 'package:habitbot/features/auth/domain/entities/user_entity.dart';
import 'package:habitbot/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<(Failure?, UserEntity?)> call({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    return await repository.signup(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
  }
}
