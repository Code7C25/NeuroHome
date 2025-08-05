import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neurohome',
      home: const PaginaPrincipal(),
    );
  }
}

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NEUROHOME'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FuncionesPage()),
                );
              },
              child: const Text('FUNCIONES'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PanelControlPage()),
                );
              },
              child: const Text('PANEL DE CONTROL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OpcionesUsuarioPage()),
                );
              },
              child: const Text('OPCIONES DE USUARIO'),
            ),
          ],
        ),
      ),
    );
  }
}

class FuncionesPage extends StatelessWidget {
  const FuncionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Funciones')),
      body: const Center(child: Text('Aquí van las funciones')),
    );
  }
}

class PanelControlPage extends StatelessWidget {
  const PanelControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Control')),
      body: const Center(child: Text('Aquí va el panel de control')),
    );
  }
}

class OpcionesUsuarioPage extends StatelessWidget {
  const OpcionesUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opciones de Usuario')),
      body: const Center(child: Text('Aquí van las opciones de usuario')),
    );
  }
}