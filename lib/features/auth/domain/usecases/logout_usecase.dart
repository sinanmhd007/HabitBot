import 'package:habitbot/core/error/failures.dart';
import 'package:habitbot/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<(Failure?, void)> call() async {
    return await repository.logout();
  }
}
