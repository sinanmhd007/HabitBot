import 'package:habitbot/core/error/exceptions.dart';
import 'package:habitbot/core/error/failures.dart';
import 'package:habitbot/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:habitbot/features/auth/domain/entities/user_entity.dart';
import 'package:habitbot/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<(Failure?, UserEntity?)> login({required String email, required String password}) async {
    try {
      final user = await remoteDataSource.login(email: email, password: password);
      return (null, user);
    }  on AuthException catch (_) {
      return (AuthFailure('Invalid email or password'), null);
    } catch (e) {
      return (ServerFailure(), null);
    }
  }

  @override
  Future<(Failure?, UserEntity?)> signup({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final user = await remoteDataSource.signup(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      return (null, user);
    } on AuthException catch (e) {
      return (AuthFailure(e.message), null);
    } catch (e) {
      return (ServerFailure(), null);
    }
  }

  @override
  Future<(Failure?, void)> logout() async {
    try {
      await remoteDataSource.logout();
      return (null, null);
    }  on AuthException catch (e) {
      return (AuthFailure(e.message), null);
    } catch (e) {
      return (ServerFailure(), null);
    }
  }

  @override
  Future<(Failure?, UserEntity?)> checkAuthStatus() async {
    try {
      final user = await remoteDataSource.checkAuthStatus();
      if (user != null) {
        return (null, user);
      }
      return (null, null);
    } catch (e) {
      return (ServerFailure(e.toString()), null);
    }
  }
}
