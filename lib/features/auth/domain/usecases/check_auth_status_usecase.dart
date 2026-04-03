import 'package:habitbot/core/error/failures.dart';
import 'package:habitbot/features/auth/domain/entities/user_entity.dart';
import 'package:habitbot/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<(Failure?, UserEntity?)> call() async {
    return await repository.checkAuthStatus();
  }
}
