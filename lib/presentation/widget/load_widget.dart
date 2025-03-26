import 'package:flutter/material.dart';

class LoadWidget extends StatelessWidget {
  /// [message] Mensaje opcional que se muestra debajo del indicador de carga.
  final String? message;
  const LoadWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos verticalmente.
        children: [
          const CircularProgressIndicator(), // Indicador de carga animado.
          const SizedBox(height: 30), // Espaciado entre el indicador y el texto.
          if (message != null && message!.isNotEmpty)
            Text(message!) // Muestra el mensaje si está definido y no está vacío.
        ],
      ),
    );
  }
}
