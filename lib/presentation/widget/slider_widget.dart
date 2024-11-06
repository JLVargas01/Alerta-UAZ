import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  final double initialValue;
  final double min;
  final double max;
  final int? division;
  final Function(double) onChange;

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
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

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
        label: _currentValue.toStringAsFixed(0),
        onChanged: _onSliderChanged);
  }
}
