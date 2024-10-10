import 'package:alerta_uaz/data/data_sources/remote/google_sign_in_service.dart';
import 'package:alerta_uaz/data/repositories/auth_repository_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthEvent {}

class CheckUserAuthentication extends AuthEvent {}

class SignIn extends AuthEvent {}

class SignOut extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthLoading extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl _authRepositoryImpl =
      AuthRepositoryImpl(GoogleSignInService());

  AuthBloc() : super(AuthInitial()) {
    on<CheckUserAuthentication>((event, emit) async {
      GoogleSignInAccount? user = _authRepositoryImpl.getUserGoogle();
      if (user == null) {
        emit(Unauthenticated());
      }
      emit(Authenticated());
    });

    on<SignIn>((event, emit) async {
      emit(AuthLoading());
      try {
        final GoogleSignInAccount? googleUser =
            await _authRepositoryImpl.logInGoogle();

        if (googleUser == null) {
          emit(AuthError('El correo no existe.'));
        }

        // Lógica para registrar el usuario

        emit(Authenticated());
      } catch (e) {
        emit(AuthError('Error al iniciar sesión: $e'));
      }
    });

    on<SignOut>((event, emit) async {
      emit(AuthLoading());
      await _authRepositoryImpl.logOutGoogle();
      emit(Unauthenticated());
    });
  }
}
