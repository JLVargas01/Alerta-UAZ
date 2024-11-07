// request_phone_page.dart

import 'package:alerta_uaz/application/authentication/auth_bloc.dart';
import 'package:alerta_uaz/application/authentication/auth_event.dart';
import 'package:alerta_uaz/application/authentication/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// request_phone_page.dart
class RequestPhonePage extends StatefulWidget {
  const RequestPhonePage({super.key});

  @override
  _RequestPhonePageState createState() => _RequestPhonePageState();
}

class _RequestPhonePageState extends State<RequestPhonePage> {
  final TextEditingController _controller = TextEditingController();
  PhoneNumber? _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicitar Número de Teléfono"),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Activa las funciones para usuarios autenticados
            //context.read<NotificationBloc>().add(EnabledNotification());
            //context.read<AlertBloc>().add(EnabledAlert(state.user));
            //context.read<LocationBloc>().add(EnabledLocation(state.user));
            //context.read<ShakeBloc>().add(EnabledShake());
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/main');
            });
          } else if (state is AuthNeedsPhoneNumber) {
            // Redirige a la pantalla de solicitud de número de teléfono
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/requestPhone');
            });
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                _phoneNumber = number;
              },
              onInputValidated: (bool isValid) {
                if (!isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Número inválido")),
                  );
                }
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: const TextStyle(color: Colors.black),
              textFieldController: _controller,
              formatInput: true,
              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: const OutlineInputBorder(),
              hintText: "Ingresa tu número",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_phoneNumber != null) {
                  context.read<AuthBloc>().add(SignIn(_phoneNumber!.phoneNumber!));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Por favor, ingresa un número válido")),
                  );
                }
              },
              child: const Text("Continuar"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
