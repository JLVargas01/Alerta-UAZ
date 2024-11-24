import 'package:flutter/material.dart';

class LoadWidget extends StatelessWidget {
  final String? message;
  const LoadWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 30,
        ),
        if (message != null && message!.isNotEmpty) Text(message!)
      ],
    ));
  }
}
