import 'package:flutter/material.dart';

class TextfieldEjemplo extends StatelessWidget {
  const TextfieldEjemplo({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(hintText: "Escribi tu nombre", border: OutlineInputBorder()),),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(hintText: "Escribi tu nombre", prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(hintText: "Escribi tu contraseña", prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 5,
            maxLength: 100,
            decoration: InputDecoration(hintText: "Escribi tu comentario", prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),),
        ),
      
      
      ]
        );
  }
}