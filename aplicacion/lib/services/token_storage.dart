import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  // Creamos la instancia de almacenamiento seguro
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'jwt_token';

  // Guardar el token (Login)
  static Future<void> save(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // Leer el token (Para enviar peticiones)
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Borrar el token (Logout)
  static Future<void> delete() async {
    await _storage.delete(key: _keyToken);
  }
}