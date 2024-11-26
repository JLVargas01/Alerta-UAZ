import 'package:alerta_uaz/application/authentication/auth_event.dart';
import 'package:alerta_uaz/application/authentication/auth_state.dart';

import 'package:alerta_uaz/data/data_sources/local/user_storange.dart';
import 'package:alerta_uaz/data/data_sources/remote/firebase_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/google_sign_in_service.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_service.dart';
import 'package:alerta_uaz/data/repositories/auth_repository_imp.dart';
import 'package:alerta_uaz/domain/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl _authRepositoryImpl =
      AuthRepositoryImpl(GoogleSignInService(), UserService());
  User userRegistrer = User();

  AuthBloc() : super(Unauthenticated()) {
    on<CheckUserAuthentication>((event, emit) async {
      emit(AuthLoading());
      User? user = await UserStorage.getUserData();
      await Future.delayed(const Duration(milliseconds: 3000));
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

        userRegistrer.name = googleUser.displayName ?? "";
        userRegistrer.email = googleUser.email;
        userRegistrer.avatar = googleUser.photoUrl ?? "";
        Map<String, dynamic>? responseDataGetted = await _authRepositoryImpl.getDataUserByEmail(googleUser.email);
        if(responseDataGetted == null){
          //Nuevo usuario
          userRegistrer.token = await FirebaseService().getToken() ?? "";
          emit(AuthNeedsPhoneNumber());
        }else{
          //Antiguo usuario
          final phoneData = responseDataGetted["phone"];
          userRegistrer.phone = "${phoneData["countryCode"]}${phoneData["nacionalNumber"]}";
          userRegistrer.token = responseDataGetted['token'];
          userRegistrer.idContactList = responseDataGetted['idContactList'];
          userRegistrer.idAlertList = responseDataGetted['idAlertList'];
          emit(Authenticated(userRegistrer));
        }

      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<ProvidePhoneNumber>((event, emit) async {
      emit(AuthLoading());
      try {
        userRegistrer.phone = event.phoneNumber;

        // Realiza el registro completo en el repositorio
        final responseData = await _authRepositoryImpl.signInUser(
          userRegistrer.name!,
          userRegistrer.email!,
          userRegistrer.phone!,
          userRegistrer.avatar!,
          userRegistrer.token!,
        );

        if (responseData == null) {
          emit(AuthError('Error al iniciar sesión, por favor inténtelo más tarde'));
          return;
        }
        userRegistrer.id = responseData['_id'];
        userRegistrer.idContactList = responseData['idContactList'];
        userRegistrer.idAlertList = responseData['idAlertList'];
        UserStorage.store(userRegistrer);
        emit(Authenticated(userRegistrer));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignOut>((event, emit) async {
      emit(AuthLoading());
      await UserStorage.clearUser();
      await _authRepositoryImpl.logOutGoogle();
      emit(Unauthenticated());
    });
  }
}
