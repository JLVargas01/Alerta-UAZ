/*
/// Pantalla para mostrar un formulario para ingresar un número telefónico
/// y confirmar que este sea correcto
*/

import 'package:alerta_uaz/application/notification/notification_bloc.dart';
import 'package:alerta_uaz/application/notification/notification_event.dart';
import 'package:alerta_uaz/presentation/widget/load_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_bloc.dart';
import 'package:alerta_uaz/application/alert/alert_event.dart';
import 'package:alerta_uaz/application/authentication/auth_event.dart';
import 'package:alerta_uaz/application/authentication/auth_state.dart';
import 'package:alerta_uaz/application/authentication/auth_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RequestPhonePage extends StatefulWidget {
  const RequestPhonePage({super.key});

  @override
  State<RequestPhonePage> createState() => _RequestPhonePageState();
}

class _RequestPhonePageState extends State<RequestPhonePage> {
  final TextEditingController _controller = TextEditingController();
  PhoneNumber? _phoneNumber;
  bool _isPhoneValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Solicitar Número de Teléfono"),
        leading: IconButton(
          onPressed: () {
            context.read<AuthBloc>().add(CancelAuth());
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Activa las funciones para usuarios autenticados
            context.read<NotificationBloc>().add(EnabledNotification());
            context.read<AlertBloc>().add(EnabledAlert());

            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home', (Route<dynamic> route) => false);
          }
          if (state is AuthError) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Error al autenticar'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const LoadWidget();
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        _phoneNumber = number;
                      },
                      onInputValidated: (bool isValid) {
                        if (_isPhoneValid != isValid) {
                          setState(() {
                            _isPhoneValid = isValid;
                          });
                        }
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      initialValue: PhoneNumber(isoCode: 'MX'),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      textFieldController: _controller,
                      formatInput: true,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: const OutlineInputBorder(),
                      hintText: "Ingresa tu número",
                    ),
                    const SizedBox(height: 20),
                    if (!_isPhoneValid)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Número no válido",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        if (_phoneNumber != null && _isPhoneValid) {
                          context.read<AuthBloc>().add(
                              ProvidePhoneNumber(_phoneNumber!.phoneNumber!));
                        } else {
                          setState(() {
                            _isPhoneValid = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Por favor, ingresa un número válido")),
                          );
                        }
                      },
                      child: const Text("Continuar"),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
