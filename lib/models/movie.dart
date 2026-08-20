class Movie {
  final String name;
  final int id;
  final String description;
  final String ReleaseDate;
  final double rating;
  final String posterPath;

  String get title => name;
  String get image => posterPath;

  const Movie({
    required this.name,
    required this.id,
    required this.description,
    required this.ReleaseDate,
    required this.rating,
    required this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['title'] ?? '',
      id: json['id'] ?? 0,
      description: json['overview'] ?? '',
      ReleaseDate: json['release_date'] ?? '',
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] ?? '',
    );
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      name: map['name'] as String? ?? '',
      id: (map['id'] as num?)?.toInt() ?? 0,
      description: map['description'] as String? ?? '',
      ReleaseDate: map['releaseDate'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      posterPath: map['posterPath'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'releaseDate': ReleaseDate,
    'rating': rating,
    'posterPath': posterPath,
  };
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
