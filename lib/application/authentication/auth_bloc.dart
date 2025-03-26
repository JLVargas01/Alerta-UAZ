import 'package:alerta_uaz/application/authentication/auth_event.dart';
import 'package:alerta_uaz/application/authentication/auth_state.dart';
import 'package:alerta_uaz/data/data_sources/remote/user_api.dart';
import 'package:alerta_uaz/data/repositories/auth_with_google.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*
//
//  Clase para manejar la autenticación.
//  _authGoogle: Variable final para realizar la comunicacion
//  con los servicios de google
//
*/
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authGoogle = AuthWithGoogle(UserApi());

  AuthBloc() : super(Unauthenticated()) {

    /*
    //  Verificar si el usuario esta autenticado en los servicios de google
    //  y emitir el estado 'Authenticated' o 'Unauthenticated'
    */
    on<CheckUserAuthentication>((event, emit) async {
      emit(AuthLoading());
      final isAuthenticated = await _authGoogle.checkUserAuthentication();
      await Future.delayed(const Duration(milliseconds: 3000));
      if (isAuthenticated != null) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });

    /*
    //  Iniciar sesion con los servicios de google, si no se esta registrado,
    //  se solicita el numero de telefono.
    //  Si ocurre un error, se cierra la sesion.
    */
    on<SignIn>((event, emit) async {
      emit(AuthLoading());
      try {
        final isAuthenticated = await _authGoogle.signIn();

        // Existe registro del usuario, se autentica
        if (isAuthenticated != null) {
          emit(Authenticated());
        } else {
          // El usuario no esta registrado, realizar formulario para nuevo registro.
          emit(AuthNeedsPhoneNumber());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        await Future.delayed(const Duration(milliseconds: 500));
        emit(Unauthenticated());
      }
    });

    /*
    // Cerrar sesion con los servicios de google y emitir estado 'Unauthenticated'
    //  Si ocurre un error, se emite un mensaje de error
    */
    on<SignOut>((event, emit) async {
      try {
        emit(AuthLoading());
        await _authGoogle.signOut();
        emit(Unauthenticated());
      } catch (e) {
        AuthError(e.toString());
      }
    });

    /*
    //  Solicitar número telefónico y emitir estado 'Authenticated'
    //  Si ocurre un error, se emite un mensaje de error.
    */
    on<ProvidePhoneNumber>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authGoogle.requestPhone(event.phoneNumber);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    /*
    //  Cancelar autenticacion
    //  Si ocurre un error, se emite un mensaje de error.
    */
    on<CancelAuth>(
      (event, emit) {
        _authGoogle.cancelAuth();
        emit(Unauthenticated());
      },
    );
  }
}
