class Movie {
  final int id;
  final String title;
  final String description;
  final int year;
  final String genre;
  final double stars;
  final String imageUrl;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.year,
    required this.genre,
    required this.stars,
    required this.imageUrl,
  });

  // Constructor para crear un Movie desde JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      year: json['year'] ?? 0,
      genre: json['genre'] ?? '',
      stars: (json['stars'] ?? 0).toDouble(),
      imageUrl: json['image_url'] ?? '',
    );
  }

  // Método para convertir Movie a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'year': year,
      'genre': genre,
      'stars': stars,
      'imageUrl': imageUrl,
    };
  }
}