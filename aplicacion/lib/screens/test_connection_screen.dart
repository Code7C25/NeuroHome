// screens/test_connection_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';


class TestConnectionScreen extends StatefulWidget {
  final String locale;
  const TestConnectionScreen({super.key, required this.locale});

  @override
  State<TestConnectionScreen> createState() => _TestConnectionScreenState();
}

class _TestConnectionScreenState extends State<TestConnectionScreen> {
  String _backendResult = 'Presiona para probar';
  String _dbResult = 'Presiona para probar';
  bool _testingBackend = false;
  bool _testingDB = false;

  Future<void> _testBackend() async {
    setState(() {
      _testingBackend = true;
      _backendResult = 'Probando conexión...';
    });

    final result = await AuthService.testConnection();
    
    setState(() {
      _testingBackend = false;
      if (result['ok'] == true) {
        _backendResult = '✅ BACKEND CONECTADO\n${result['data']}';
      } else {
        _backendResult = '❌ ERROR: ${result['message']}';
      }
    });
  }

  Future<void> _testDatabase() async {
    setState(() {
      _testingDB = true;
      _dbResult = 'Probando base de datos...';
    });

    final result = await AuthService.testDatabase();
    
    setState(() {
      _testingDB = false;
      if (result['ok'] == true) {
        _dbResult = '✅ DB CONECTADA\nUsuarios: ${result['data']['count']}';
      } else {
        _dbResult = '❌ ERROR DB: ${result['message']}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba de Conexión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Prueba Backend
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Prueba Backend',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _testingBackend ? null : _testBackend,
                      child: Text(_testingBackend ? 'Probando...' : 'Probar Backend'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _backendResult,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _backendResult.contains('✅') ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Prueba Base de Datos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Prueba Base de Datos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _testingDB ? null : _testDatabase,
                      child: Text(_testingDB ? 'Probando...' : 'Probar DB'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _dbResult,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _dbResult.contains('✅') ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}