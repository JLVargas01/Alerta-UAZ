import 'package:alerta_uaz/application/authentication/auth_event.dart';
import 'package:alerta_uaz/application/authentication/auth_state.dart';

import 'package:alerta_uaz/data/data_sources/local/user_storange.dart';
import 'package:alerta_uaz/data/data_sources/remote/firebase_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/google_sign_in_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_service.dart';
import 'package:alerta_uaz/data/repositories/auth_repository_imp.dart';
import 'package:alerta_uaz/domain/model/google-data_model.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl _authRepositoryImpl =AuthRepositoryImpl(GoogleSignInService(), UserService());
  final UserStorange _userStorange = UserStorange();
  GoogleData? _temporaryUser;

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
        final GoogleSignInAccount? googleUser = await _authRepositoryImpl.logInGoogle();

        if (googleUser == null) {
          emit(AuthError('Error al iniciar sesión: El correo no existe'));
          return;
        }

        // Almacena temporalmente la información del usuario de Google en `_temporaryUser`
        _temporaryUser = GoogleData(
          nameGoogle: googleUser.displayName ?? "",
          emailGoogle: googleUser.email,
          avatarUrlGoogle: googleUser.photoUrl ?? "",
          deviceToken: await FirebaseService().getToken() ?? "",
        );

        // Solicita el número de teléfono
        emit(AuthNeedsPhoneNumber());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<CompleteSignIn>((event, emit) async {
      emit(AuthLoading());
      try {
        // Verifica que `_temporaryUser` no sea nulo
        if (_temporaryUser == null) {
          emit(AuthError('Error: No se puede completar el registro sin datos de usuario.'));
          return;
        }

        // Recupera los datos de `_temporaryUser`
        final phoneUser = event.phoneNumber;
        
        // Llama al repositorio para registrar el usuario completo
        final responseData = await _authRepositoryImpl.signInUser(
          _temporaryUser!.nameGoogle,
          _temporaryUser!.emailGoogle,
          phoneUser,
          _temporaryUser!.avatarUrlGoogle,
          _temporaryUser!.deviceToken,
        );

        if (responseData == null) {
          emit(AuthError('Error al iniciar sesión, por favor inténtelo más tarde'));
          return;
        }

        // Crea el usuario final con todos los datos completados
        User user = User(
          id: responseData['_id'],
          name: _temporaryUser!.nameGoogle,
          email: _temporaryUser!.emailGoogle,
          phone: phoneUser,
          avatar: _temporaryUser!.avatarUrlGoogle,
          deviceToken: _temporaryUser!.deviceToken,
          idContactList: responseData['id_contact_list'],
        );

        // Almacena el usuario para persistir datos y actualizar el estado a `Authenticated`
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
