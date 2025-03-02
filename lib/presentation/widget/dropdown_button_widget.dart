import 'package:flutter/material.dart';

class DropdownButtonWidget extends StatefulWidget {
  /// [items] Lista de elementos que se mostrarán en el menú desplegable.
  final List<dynamic> items;
  /// [initialValue] Valor inicial seleccionado en el dropdown.
  final dynamic initialValue;
  /// [onChange] Función callback que se ejecuta cuando cambia la selección.
  final Function(dynamic) onChange;

  DropdownButtonWidget(
      {super.key,
      required this.items,
      required this.initialValue,
      required this.onChange})
      : assert(
            items.contains(initialValue), 'initialValue debe estar en items.');

  @override
  State<DropdownButtonWidget> createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  /// [_currentValue] Almacena el valor seleccionado actualmente.
  late dynamic _currentValue;

  @override
  void initState() {
    super.initState();
    /// Inicializa el valor con el proporcionado en 'initialValue'.
    _currentValue = widget.initialValue;
  }

  void _onDropdownChanged(dynamic newValue) {
    setState(() {
      _currentValue = newValue;
    });
    widget.onChange(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: _currentValue,
        items: widget.items.map<DropdownMenuItem<dynamic>>(
          (dynamic item) {
            return DropdownMenuItem(
                  // Crea una lista de opciones en el dropdown.
                  value: item, child: Text(item.toString())
                  );
          },
        ).toList(),
        // Llama a la función cuando se selecciona un nuevo valor.
        onChanged: _onDropdownChanged
    );
  }
}
