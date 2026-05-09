import 'package:habitbot/core/error/failures.dart';
import 'package:habitbot/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<(Failure?, UserEntity?)> login({required String email, required String password});
  Future<(Failure?, UserEntity?)> signup({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  });
  Future<(Failure?, void)> logout();
  Future<(Failure?, UserEntity?)> checkAuthStatus();
  Future<(Failure?, UserEntity?)> updateUser(UserEntity user);
}
