import 'package:alerta_uaz/application/contact-list_bloc.dart';
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
  State<CompletePhonePage> createState() => _CompleteNumberPageState();
}

class _CompleteNumberPageState extends State<CompletePhonePage> {
  final TextEditingController _phoneController = TextEditingController();
  String? _validatedPhoneNumber;
  PhoneNumber? _initialPhoneNumber;

  @override
  void initState() {
    super.initState();

    // Detecta y ajusta el número inicial con su countryCode
    PhoneNumber.getRegionInfoFromPhoneNumber(widget.initialPhoneNumber)
        .then((phoneNumber) {
      setState(() {
        _initialPhoneNumber = phoneNumber;
        _phoneController.text = phoneNumber.phoneNumber ?? widget.initialPhoneNumber;
      });
    }).catchError((_) {
      // Si no puede detectar, establece un valor por defecto
      setState(() {
        _initialPhoneNumber = PhoneNumber(phoneNumber: widget.initialPhoneNumber, isoCode: 'MX');
      });
    });
  }

  void _submitNumber() {
    if (_validatedPhoneNumber != null) {
      // Agregar el contacto y regresar
      context.read<ContactsBloc>().add(AddContact(
        _validatedPhoneNumber!,
        widget.contactName,
      ));
      Navigator.of(context).pop(); // Cierra la página después de confirmar
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, valida el número correctamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validar número de contacto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Validar número para: ${widget.contactName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (_initialPhoneNumber != null)
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
