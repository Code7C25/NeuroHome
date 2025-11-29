import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class SensorService {
  // Usamos localhost porque estás en Chrome/Windows
  static const String _baseUrl = 'http://localhost:3000/api'; 

  static Future<Map<String, dynamic>> getSensorData() async {
    try {
      final token = await TokenStorage.getToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/sensors/data'), 
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        
        if (jsonResponse['ok'] == true) {
          // Extraemos los datos limpios
          return {
            'ok': true,
            'data': jsonResponse['data'] // Aquí viene temp, humidity, etc.
          };
        }
      }
      return {'ok': false};
    } catch (e) {
      print('Error sensor service: $e');
      return {'ok': false};
    }
  }
}