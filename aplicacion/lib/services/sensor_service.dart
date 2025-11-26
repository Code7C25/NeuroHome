// services/sensor_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class SensorService {
  static const String _base = 'http://10.0.2.2:3000/api'; // Android emulator

  // Obtener datos de sensores
  static Future<Map<String, dynamic>> getSensorData() async {
    final uri = Uri.parse('$_base/sensors/data');
    try {
      final resp = await http.get(uri);
      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
      
      if (resp.statusCode == 200) {
        return {'ok': true, 'data': body['data']};
      } else {
        return {'ok': false, 'message': 'Error al obtener datos'};
      }
    } catch (e) {
      return {'ok': false, 'message': 'Error de conexión: $e'};
    }
  }
}