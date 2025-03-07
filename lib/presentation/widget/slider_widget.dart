import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  final double initialValue; // Valor inicial del slider.
  final double min; // Valor mínimo permitido en el slider.
  final double max; // Valor máximo permitido en el slider.
  final int? division; // Número opcional de divisiones en el slider.
  final Function(double) onChange; // Función que se ejecuta cuando el valor cambia.

  const SliderWidget(
      {super.key,
      required this.initialValue,
      required this.min,
      required this.max,
      this.division,
      required this.onChange})
      : assert((initialValue >= min && initialValue <= max),
            'initialValue debe estar dentro del rango min y max.');

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late double _currentValue; // Valor actual del slider.

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  // Método que actualiza el valor del slider y ejecuta la función onChange.
  void _onSliderChanged(double newValue) {
    setState(() {
      _currentValue = newValue;
    });
    widget.onChange(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentValue,
      min: widget.min,
      max: widget.max,
      divisions: widget.division,
      label: _currentValue.toStringAsFixed(0), // Muestra el valor actual como etiqueta.
      onChanged: _onSliderChanged,
    );
  }
}
