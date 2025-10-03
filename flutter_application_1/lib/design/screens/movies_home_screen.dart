import 'package:flutter/material.dart';
import '../../data/api_service.dart';
import '../../models/movie.dart';
import '../widgets/movie_card.dart';

class MoviesHomeScreen extends StatefulWidget {
  const MoviesHomeScreen({super.key});

  @override
  State<MoviesHomeScreen> createState() => _MoviesHomeScreenState();
}

class _MoviesHomeScreenState extends State<MoviesHomeScreen> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    // Inicializar el Future que cargará las películas
    _moviesFuture = ApiService.fetchMovies(); 
  }

  // Método para refrescar los datos
  Future<void> _refreshMovies() async {
    setState(() {
      _moviesFuture = ApiService.fetchMovies(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Películas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMovies,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMovies,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Movie>>(
            future: _moviesFuture,
            builder: (context, snapshot) {
              // Mientras está cargando
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Cargando películas...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              // Si hay un error
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar películas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshMovies,
                        child: const Text('Intentar de nuevo'),
                      ),
                    ],
                  ),
                );
              }
              
              // Si los datos están disponibles
              if (snapshot.hasData) {
                final movies = snapshot.data!;
                
                // Si no hay películas
                if (movies.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay películas disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                // Mostrar lista de películas
                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MovieCard(movie: movies[index]);
                  },
                );
              }
              
              // Estado por defecto (nunca debería llegar aquí)
              return const Center(
                child: Text('Sin datos disponibles'),
              );
            },
          ),
        ),
      ),
    );
  }
}