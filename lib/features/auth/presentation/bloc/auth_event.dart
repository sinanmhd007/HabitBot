import 'package:equatable/equatable.dart';
import 'package:habitbot/features/auth/domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignupEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  const SignupEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [name, email, password, phoneNumber];
}

class LogoutEvent extends AuthEvent {}

class UpdateUserEvent extends AuthEvent {
  final UserEntity user;

  const UpdateUserEvent(this.user);

  @override
  List<Object> get props => [user];
}
