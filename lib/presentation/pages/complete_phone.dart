/*
/// Pantalla para mostrar un formulario para ingresar un número telefónico
/// y confirmar que este sea correcto
*/

import 'package:alerta_uaz/application/contact/contact_bloc.dart';
import 'package:alerta_uaz/application/contact/contact_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CompletePhonePage extends StatefulWidget {
  final String initialPhoneNumber;
  final String contactName;

  const CompletePhonePage({
    super.key,
    required this.initialPhoneNumber,
    required this.contactName,
  });

  @override
  State<CompletePhonePage> createState() => _CompletePhonePageState();
}

class _CompletePhonePageState extends State<CompletePhonePage> {
  final TextEditingController _phoneController = TextEditingController();
  String? _validatedPhoneNumber;
  PhoneNumber? _initialPhoneNumber;

  @override
  void initState() {
    super.initState();
    _initializePhoneNumber();
  }

  void _initializePhoneNumber() {
    // Si el número tiene prefijo internacional, lo usamos tal cual.
    if (widget.initialPhoneNumber.startsWith('+')) {
      PhoneNumber.getRegionInfoFromPhoneNumber(widget.initialPhoneNumber)
          .then((phoneNumber) {
        setState(() {
          _initialPhoneNumber = phoneNumber;
          _phoneController.text =
              phoneNumber.phoneNumber ?? widget.initialPhoneNumber;
        });
      }).catchError((error) {
        debugPrint('Error al obtener información del número: $error');
        // En caso de error, inicializa con el número proporcionado.
        setState(() {
          _initialPhoneNumber = PhoneNumber(
              phoneNumber: widget.initialPhoneNumber, isoCode: 'MX');
        });
      });
    } else {
      // Si no tiene prefijo, inicializamos con un valor predeterminado.
      setState(() {
        _initialPhoneNumber =
            PhoneNumber(phoneNumber: widget.initialPhoneNumber, isoCode: 'MX');
        _phoneController.text = widget.initialPhoneNumber;
      });
    }
  }

  void _submitNumber() {
    if (_validatedPhoneNumber != null) {
      context.read<ContactsBloc>().add(AddContact(
            _validatedPhoneNumber!,
            widget.contactName,
          ));
      Navigator.of(context).pop(); // Cierra la página después de confirmar.
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, valida el número correctamente.')),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validar número de contacto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _initialPhoneNumber == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Validar número para: ${widget.contactName}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      setState(() {
                        _validatedPhoneNumber = number.phoneNumber;
                      });
                    },
                    onInputValidated: (bool isValid) {
                      if (!isValid) {
                        setState(() {
                          _validatedPhoneNumber = null;
                        });
                      }
                    },
                    initialValue: _initialPhoneNumber,
                    textFieldController: _phoneController,
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    formatInput: true,
                    keyboardType: TextInputType.phone,
                    inputDecoration: const InputDecoration(
                      labelText: 'Número de teléfono',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitNumber,
                    child: const Text('Confirmar número'),
                  ),
                ],
              ),
      ),
    );
  }
}
