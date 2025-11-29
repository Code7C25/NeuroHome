// screens/single_camera_screen.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SingleCameraScreen extends StatefulWidget {
  final String locale;

  const SingleCameraScreen({super.key, required this.locale});

  @override
  State<SingleCameraScreen> createState() => _SingleCameraScreenState();
}

class _SingleCameraScreenState extends State<SingleCameraScreen> {
  late final WebViewController controller;
  bool _isLoading = true;
  bool _isFullscreen = false;

  // URL de tu cámara - cambia por la IP real
  final String _cameraLocalUrl = 'http://172.20.10.4:81/stream'; //pone la IP correcta :81/stream no funciona, prueba solo la IP http://192.168.1.45 o http://192.168.1.45:80/stream
  //Guarda el archivo.
  //Reinicia la App (R).
  final String _cameraRemoteUrl = 'http://tudominio.com/camara'; // Opcional

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) => setState(() => _isLoading = true),
        onPageFinished: (url) => setState(() => _isLoading = false),
        onWebResourceError: (error) {
          setState(() => _isLoading = false);
          print('Error cámara: ${error.description}');
        },
      ))
      ..loadRequest(Uri.parse(_cameraLocalUrl)); // Intenta local primero
  }

  void _refreshStream() {
    setState(() => _isLoading = true);
    controller.reload();
  }

  void _toggleFullscreen() {
    setState(() => _isFullscreen = !_isFullscreen);
  }

  void _switchToRemote() {
    setState(() => _isLoading = true);
    controller.loadRequest(Uri.parse(_cameraRemoteUrl));
  }

  void _switchToLocal() {
    setState(() => _isLoading = true);
    controller.loadRequest(Uri.parse(_cameraLocalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullscreen ? null : AppBar(
        title: const Text('Cámara de Seguridad'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          // Selector local/remoto
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (value) {
              if (value == 'local') _switchToLocal();
              if (value == 'remote') _switchToRemote();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'local',
                child: Text('Modo Local'),
              ),
              const PopupMenuItem(
                value: 'remote', 
                child: Text('Modo Remoto'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: _toggleFullscreen,
            tooltip: 'Pantalla completa',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshStream,
            tooltip: 'Refrescar cámara',
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Stream de la cámara
          WebViewWidget(controller: controller),
          
          // Loading indicator
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Conectando con la cámara...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          
          // Botón de salir de fullscreen
          if (_isFullscreen)
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.fullscreen_exit, color: Colors.white, size: 30),
                onPressed: _toggleFullscreen,
              ),
            ),
        ],
      ),
    );
  }
}