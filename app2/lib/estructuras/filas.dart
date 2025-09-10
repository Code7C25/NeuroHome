import 'dart:ffi';

import 'package:flutter/material.dart';

class FilasEjemplos extends StatelessWidget {
  const FilasEjemplos({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 86, left: 12, right: 12, bottom: 86),
      child: SizedBox(
        // height: double.infinity,
        child: const Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Ejemplo 1"),
            Expanded(child: Text("Ejemplo 2")),
            Text("Ejemplo 3"),
          ],
        ),
      ),
    );
  }
}