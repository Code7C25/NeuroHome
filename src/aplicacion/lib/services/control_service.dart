// lib/services/control_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart'; // Asegúrate de importar esto

class ControlService {
  // Ajusta la IP a la de tu PC
  static const String _baseUrl = 'http://localhost:3000/api'; 

  static Future<bool> sendCommand(String device, String action) async {
    final token = await TokenStorage.getToken();
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/control'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Si tu backend pide token
        },
        body: jsonEncode({'device': device, 'action': action}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error control: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error conexión: $e');
      return false;
    }
  }
}