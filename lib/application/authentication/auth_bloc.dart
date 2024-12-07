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
      final isAuthenticated = await _authGoogle.checkUserAuthentication();

      if (isAuthenticated != null) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });

    on<SignIn>((event, emit) async {
      emit(AuthLoading());
      try {
// <<<<<<< HEAD
        final isAuthenticated = await _authGoogle.signIn();

        // Existe registro del usuario, se autentica
        if (isAuthenticated != null) {
          emit(Authenticated());
        } else {
          // El usuario no esta registrado, realizar formulario para nuevo registro.
          emit(AuthNeedsPhoneNumber());
        }
// =======
//         await _authGoogle.signIn();
//         emit(AuthNeedsPhoneNumber());
// >>>>>>> development
      } catch (e) {
        emit(AuthError(e.toString()));
        await Future.delayed(const Duration(milliseconds: 500));
        emit(Unauthenticated());
      }
    });

    on<SignOut>((event, emit) async {
      try {
        emit(AuthLoading());
        await _authGoogle.signOut();
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
      }
    });

    on<CancelAuth>(
      (event, emit) {
        _authGoogle.cancelAuth();
        emit(Unauthenticated());
      },
    );
  }
}
