import 'package:flutter/material.dart';

class DropdownButtonWidget extends StatefulWidget {
  final List<dynamic> items;
  final dynamic initialValue;
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
  late dynamic _currentValue;

  @override
  void initState() {
    super.initState();
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
            return DropdownMenuItem(value: item, child: Text(item.toString()));
          },
        ).toList(),
        onChanged: _onDropdownChanged);
  }
}
