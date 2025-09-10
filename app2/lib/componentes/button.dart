import 'package:flutter/material.dart';

class ButtonEjemplo extends StatelessWidget {
  const ButtonEjemplo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        ElevatedButton(onPressed: () {print("presionado");}, child: Text("Presionar"), style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),),
        
        OutlinedButton(onPressed: null, child: Text("outlined")),
        
        TextButton(onPressed: () {}, child: Text("text button")),

        FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),

        IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
        Spacer(),
      ],


    );
  }
}