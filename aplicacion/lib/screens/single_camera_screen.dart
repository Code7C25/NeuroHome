// VERSIÓN MÁS SIMPLE Y DIRECTA
import 'dart:async';
import 'package:flutter/material.dart';

class SingleCameraScreen extends StatefulWidget {
  final String locale;

  const SingleCameraScreen({super.key, required this.locale});

  @override
  State<SingleCameraScreen> createState() => _SingleCameraScreenState();
}

class _SingleCameraScreenState extends State<SingleCameraScreen> {
  Timer? _refreshTimer;
  int _counter = 0;

  final String cameraUrl = 'http://10.114.34.169/capture';

  @override
  void initState() {
    super.initState();
    // ✅ REFRESCO SIMPLE CADA 2 SEGUNDOS
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _counter++;
        });
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara de Seguridad'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _counter++),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          '$cameraUrl?t=${DateTime.now().millisecondsSinceEpoch}&refresh=$_counter',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam_off, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Error cargando cámara',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}