import 'package:app2/componentes/button.dart';
import 'package:app2/componentes/imagen.dart';
import 'package:app2/componentes/text.dart';
import 'package:app2/componentes/textfield.dart';
import 'package:app2/estructuras/columnas.dart';
import 'package:app2/estructuras/filas.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: ImagenEjemplo(),
      ),
    );
  }
}

