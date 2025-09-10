import 'package:flutter/material.dart';

class ColumnasEjemplos extends StatelessWidget {
  const ColumnasEjemplos({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(92, 66, 154, 1),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Ejemplo de Columnas de naku de naku de naku")
        ],
      ),
    );
  }
}
