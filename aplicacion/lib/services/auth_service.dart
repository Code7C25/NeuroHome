import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Emulador Android -> 10.0.2.2 ; iOS simulator -> localhost ; dispositivo real -> IP de tu PC
  static const String _base = 'http://localhost:3000/api';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final uri = Uri.parse('$_base/auth/login');
    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
      if (resp.statusCode == 200) {
        return {'ok': true, 'data': body};
      } else {
        return {'ok': false, 'message': body['message'] ?? 'Error en el servidor'};
      }
    } catch (e) {
      return {'ok': false, 'message': 'No se pudo conectar al servidor'};
    }
  }
  // Método de prueba de conexión - NUEVO
  static Future<Map<String, dynamic>> testConnection() async {
    final uri = Uri.parse('$_base/test');
    try {
      final resp = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
      if (resp.statusCode == 200) {
        return {'ok': true, 'data': body};
      } else {
        return {'ok': false, 'message': 'Error ${resp.statusCode}'};
      }
    } catch (e) {
      return {'ok': false, 'message': 'No se pudo conectar: $e'};
    }
  }

  // Método para probar la base de datos - NUEVO
  static Future<Map<String, dynamic>> testDatabase() async {
    final uri = Uri.parse('$_base/test-db');
    try {
      final resp = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
      if (resp.statusCode == 200) {
        return {'ok': true, 'data': body};
      } else {
        return {'ok': false, 'message': 'Error ${resp.statusCode}'};
      }
    } catch (e) {
      return {'ok': false, 'message': 'Error DB: $e'};
    }
  }
 static Future<Map<String, dynamic>> register(
    String username, 
    String password, 
    String email, 
    String name
  ) async {
    final uri = Uri.parse('$_base/auth/register');
    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
          'name': name,
        }),
      );

      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return {'ok': true, 'data': body};
      } else {
        return {'ok': false, 'message': body['message'] ?? 'Error en el registro'};
      }
    } catch (e) {
      return {'ok': false, 'message': 'No se pudo conectar al servidor: $e'};
    }
  }
}
