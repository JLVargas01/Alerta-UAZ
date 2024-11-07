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
          return;
        }
        String nameUser = googleUser.displayName ?? "";
        String emailUser = googleUser.email;
        String avatarUserUrl = googleUser.photoUrl ?? "";
        String deviceToken = await FirebaseService().getToken() ?? "";

        // Verificar si el usuario tiene un número almacenado
        String? phoneUser = event.phoneNumber;
        if (phoneUser == null || phoneUser.isEmpty) {
        // Solicitar número de teléfono si no está almacenado
          emit(AuthNeedsPhoneNumber());
          return;
        }

        final responseData = 
          await _authRepositoryImpl.signInUser(nameUser, emailUser, phoneUser, avatarUserUrl, deviceToken);

        if (responseData == null) {
          emit(AuthError(
              'Error al iniciar sesión, por favor intentelo más tarde'));
          return;
        }

        // Lógica para registrar el usuario
        User user = User(
          id: responseData['_id'],
          name: nameUser,
          email: emailUser,
          phone: phoneUser,
          avatar: avatarUserUrl,
          deviceToken: deviceToken,
          idContactList: responseData['id_contact_list']
        );

        // Almacenamos el usuario para persistir los datos
        // en caso de cerrar la aplicación por completo
        _userStorange.store(user);
        emit(Authenticated(user));
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
