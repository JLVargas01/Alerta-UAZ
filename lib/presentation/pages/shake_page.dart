import 'package:flutter/material.dart';

class ShakePage extends StatelessWidget {
  const ShakePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shake detectado'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tiempo restante'),
            const Text('5'),
            const SizedBox(
              height: 50,
            ),
            const Text('Cantidad de shake detectadas'),
            const Text('1'),
            const SizedBox(
              height: 45,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Desactivar shake'))
          ],
        ),
      ),
    );
  }
}
