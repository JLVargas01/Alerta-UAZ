import 'package:alerta_uaz/application/authentication/auth_event.dart';
import 'package:alerta_uaz/application/authentication/auth_state.dart';

import 'package:alerta_uaz/data/data_sources/remote/user_api.dart';
import 'package:alerta_uaz/data/repositories/auth_with_google.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authGoogle = AuthWithGoogle(UserApi());

  AuthBloc() : super(Unauthenticated()) {
    on<CheckUserAuthentication>((event, emit) async {
      emit(AuthLoading());
      bool isAuthenticated = await _authGoogle.checkUserAuthentication();

      if (isAuthenticated) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });

    on<SignIn>((event, emit) async {
      emit(AuthLoading());
      try {
        /* CODIGO COMENTADO
        final googleUser = await _authRepositoryImpl.logInGoogle();
        if (googleUser == null) {
          emit(AuthError('Error al iniciar sesión: El correo no existe'));
          return;
        }
        userRegistrer.name = googleUser.displayName ?? "";
        userRegistrer.email = googleUser.email;
        userRegistrer.avatar = googleUser.photoUrl ?? "";
        Map<String, dynamic>? responseDataGetted =
            await _authRepositoryImpl.getDataUserByEmail(googleUser.email);
        if (responseDataGetted == null) {
          //Nuevo usuario
          userRegistrer.token = await FirebaseService().getToken() ?? "";
          emit(AuthNeedsPhoneNumber());
        } else {
          //Antiguo usuario
          userRegistrer.id = responseDataGetted['_id'];
          final phoneData = responseDataGetted["phone"];
          userRegistrer.phone ="${phoneData["countryCode"]}${phoneData["nacionalNumber"]}";
          userRegistrer.token = responseDataGetted['token'];
          userRegistrer.idContactList = responseDataGetted['id_contact_list'];
          userRegistrer.idAlertList = responseDataGetted['id_alert_list'];
          UserStorage.store(userRegistrer);
          emit(Authenticated(userRegistrer));
        }
        */
        await _authGoogle.signIn();
        emit(AuthNeedsPhoneNumber());
      } catch (e) {
        emit(AuthError(e.toString()));
        await Future.delayed(const Duration(milliseconds: 500));
        emit(Unauthenticated());
      }
    });

    on<LogIn>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _authGoogle.logIn();
          emit(Authenticated());
        } catch (e) {
          emit(AuthError(e.toString()));
          await Future.delayed(const Duration(milliseconds: 500));
          emit(Unauthenticated());
        }
      },
    );

    on<LogOut>((event, emit) async {
      try {
        emit(AuthLoading());
        await _authGoogle.logOut();
        emit(Unauthenticated());
      } catch (e) {
        AuthError(e.toString());
      }
    });

    on<ProvidePhoneNumber>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authGoogle.requestPhone(event.phoneNumber);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        await Future.delayed(const Duration(milliseconds: 500));
        emit(Unauthenticated());
      }
    });

    on<CancelAuth>(
      (event, emit) {
        emit(Unauthenticated());
      },
    );
  }
}
