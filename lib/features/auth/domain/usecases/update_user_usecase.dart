import 'package:habitbot/core/error/failures.dart';
import 'package:habitbot/features/auth/domain/entities/user_entity.dart';
import 'package:habitbot/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserUseCase {
  final AuthRepository repository;

  UpdateUserUseCase(this.repository);

  Future<(Failure?, UserEntity?)> call(UserEntity user) async {
    return await repository.updateUser(user);
  }
}
