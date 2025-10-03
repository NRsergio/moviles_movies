import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  // URL base de la API
  static const String baseUrl = 'https://devsapihub.com/api-movies';
  
  // Método para obtener todas las películas
  static Future<List<Movie>> fetchMovies() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final List<dynamic> jsonData = json.decode(response.body);
        
        // Debug: imprimir las primeras URLs para verificar
        if (jsonData.isNotEmpty) {
          print('=== DEBUG IMAGENES ===');
          for (int i = 0; i < (jsonData.length > 3 ? 3 : jsonData.length); i++) {
            print('Película ${i + 1}: ${jsonData[i]['title']}');
            print('URL imagen: ${jsonData[i]['imageUrl']}');
            print('---');
          }
        }
        
        // Convertir cada elemento JSON a un objeto Movie
        return jsonData.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar películas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener una película por ID
  static Future<Movie> fetchMovieById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Movie.fromJson(jsonData);
      } else {
        throw Exception('Error al cargar película: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener películas con límite
  static Future<List<Movie>> fetchMoviesWithLimit(int limit) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/limit/$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar películas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener películas por género
  static Future<List<Movie>> fetchMoviesByGenre(String genre) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/genre/$genre'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar películas por género: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener películas por año
  static Future<List<Movie>> fetchMoviesByYear(int year) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/year/$year'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar películas por año: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener películas por calificación
  static Future<List<Movie>> fetchMoviesByStars(double stars) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stars/$stars'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar películas por estrellas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para crear una nueva película
  static Future<Movie> createMovie(Movie movie) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/movie'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': movie.title,
          'description': movie.description,
          'year': movie.year,
          'image_url': movie.imageUrl,
          'genre': movie.genre,
          'stars': movie.stars,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Movie.fromJson(jsonData);
      } else {
        throw Exception('Error al crear película: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para actualizar una película
  static Future<Movie> updateMovie(Movie movie) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/movie/${movie.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': movie.id,
          'title': movie.title,
          'description': movie.description,
          'year': movie.year,
          'image_url': movie.imageUrl,
          'genre': movie.genre,
          'stars': movie.stars,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Movie.fromJson(jsonData);
      } else {
        throw Exception('Error al actualizar película: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para eliminar una película
  static Future<bool> deleteMovie(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/movie/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Error al eliminar película: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}