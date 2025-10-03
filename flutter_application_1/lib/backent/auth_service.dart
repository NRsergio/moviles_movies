import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:3000'; // Cambia por la URL de tu API
  final _storage = const FlutterSecureStorage();

  // Registro de usuario
  Future<bool> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    return response.statusCode == 201;
  }

  // Inicio de sesión
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'token', value: data['token']); // Guardar el token
      return true;
    }
    return false;
  }

  // Obtener el token almacenado
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Cerrar sesión
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}