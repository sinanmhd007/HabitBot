import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitbot/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:habitbot/features/auth/domain/usecases/login_usecase.dart';
import 'package:habitbot/features/auth/domain/usecases/logout_usecase.dart';
import 'package:habitbot/features/auth/domain/usecases/signup_usecase.dart';
import 'package:habitbot/features/auth/domain/usecases/update_user_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final UpdateUserUseCase updateUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
    required this.updateUserUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<LogoutEvent>(_onLogout);
    on<UpdateUserEvent>(_onUpdateUser);
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final (failure, user) = await checkAuthStatusUseCase();
    if (failure != null) {
      emit(Unauthenticated());
    } else if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final (failure, user) = await loginUseCase(email: event.email, password: event.password);
    if (failure != null) {
      emit(AuthError(failure.message));
    } else if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(const AuthError('Unexpected error occurred'));
    }
  }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final (failure, user) = await signupUseCase(
      name: event.name,
      email: event.email,
      password: event.password,
      phoneNumber: event.phoneNumber,
    );
    if (failure != null) {
      emit(AuthError(failure.message));
    } else if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(const AuthError('Unexpected error occurred'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await logoutUseCase();
    emit(Unauthenticated());
  }

  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<AuthState> emit) async {
    final (failure, user) = await updateUserUseCase(event.user);
    if (failure != null) {
      emit(AuthError(failure.message));
    } else if (user != null) {
      emit(Authenticated(user));
    }
  }
}
