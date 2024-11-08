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
  final AuthRepositoryImpl _authRepositoryImpl =AuthRepositoryImpl(GoogleSignInService(), UserService());
  final UserStorange _userStorange = UserStorange();
  User user = User();

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
        final googleUser = await _authRepositoryImpl.logInGoogle();
        if (googleUser == null) {
          emit(AuthError('Error al iniciar sesión: El correo no existe'));
          return;
        }

        user.deviceName = googleUser.displayName ?? "";
        user.deviceEmail = googleUser.email;
        user.deviceAvatar = googleUser.photoUrl ?? "";
        user.deviceToken = await FirebaseService().getToken() ?? "";

        emit(AuthNeedsPhoneNumber());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<ProvidePhoneNumber>((event, emit) async {
      emit(AuthLoading());
      try {
        user.devicePhone = event.phoneNumber;

        // Realiza el registro completo en el repositorio
        final responseData = await _authRepositoryImpl.signInUser(
          user.name,
          user.email,
          user.phone,
          user.avatar,
          user.token,
        );

        if (responseData == null) {
          emit(AuthError('Error al iniciar sesión, por favor inténtelo más tarde'));
          return;
        }

        user.deviceId = responseData['_id'];
        user.deviceIdContacts = responseData['id_contact_list'];

        _userStorange.store(user);
        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
