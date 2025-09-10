import 'package:flutter/material.dart';

class TextEjemplo extends StatelessWidget {
  const TextEjemplo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Spacer(),
        Text("Texto básico"),
        Text("Texto básico", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
        Text("Texto color", style: TextStyle(color: Colors.red, fontSize: 30, backgroundColor: Colors.amberAccent),),
        Text("Decoracion", style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: 24),),
        Text("Espacio entre letras", style: TextStyle(letterSpacing: 5, fontSize: 30),),
        Text("texto largo texto largo texto largo texto largo texto largo texto largo texto largo texto largo texto largo texto largo texto largo texto largo", style: TextStyle(letterSpacing: 5, fontSize: 20),maxLines: 2, overflow: TextOverflow.ellipsis),        
        Spacer(),
      ],
    );
  }
}