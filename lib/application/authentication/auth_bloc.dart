import 'package:alerta_uaz/application/authentication/auth_event.dart';
import 'package:alerta_uaz/application/authentication/auth_state.dart';

import 'package:alerta_uaz/data/data_sources/local/user_storange.dart';
import 'package:alerta_uaz/data/data_sources/remote/firebase_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/google_sign_in_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_service.dart';
import 'package:alerta_uaz/data/repositories/auth_repository_imp.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl _authRepositoryImpl =
      AuthRepositoryImpl(GoogleSignInService(), UserService());

  final UserStorange _userStorange = UserStorange();

  AuthBloc() : super(Unauthenticated()) {
    on<CheckUserAuthentication>((event, emit) async {
      emit(AuthLoading());

      User? user = await _userStorange.getUser();
      if (user == null) {
        emit(Unauthenticated());
      } else {
        emit(Authenticated(user));
      }
    });

    on<SignIn>((event, emit) async {
      emit(AuthLoading());
      try {
        final GoogleSignInAccount? googleUser =
            await _authRepositoryImpl.logInGoogle();

        if (googleUser == null) {
          emit(AuthError('Error al iniciar sesión: El correo no existe'));
        } else {
          // Lógica para registrar el usuario
          User? user = User(
            name: googleUser.displayName,
            email: googleUser.email,
            avatar: googleUser.photoUrl,
          );

          // Obtenemos el token del dispositivo
          user.deviceToken = (await FirebaseService().getToken())!;

          user = await _authRepositoryImpl.signInUser(user);

          // Almacenamos el usuario para persistir los datos
          // en caso de cerrar la aplicación por completo
          if (user != null) {
            _userStorange.store(user);
            emit(Authenticated(user));
          } else {
            emit(AuthError(
                'Error al iniciar sesión, por favor intentelo más tarde'));
          }
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignOut>((event, emit) async {
      emit(AuthLoading());
      await _userStorange.clearUser();
      await _authRepositoryImpl.logOutGoogle();
      emit(Unauthenticated());
    });
  }
}
