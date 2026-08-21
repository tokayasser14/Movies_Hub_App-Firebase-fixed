import 'package:dio/dio.dart';
import 'movie.dart';
import 'comment.dart';

class Service {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',

      queryParameters: {'api_key': '6961a5d3cf78c748ab254604facb546b'},
    ),
  );

  Future<List<Movie>> getmovie() async {
    try {
      final Response<dynamic> response = await dio.get('/movie/popular');
      return (response.data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to load movie: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await dio.get(
        '/search/movie',
        queryParameters: {'query': query},
      );
      return (response.data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  Future<List<Movie>> searchSeries(String query) async {
    try {
      final response = await dio.get(
        '/search/tv',
        queryParameters: {'query': query},
      );
      return (response.data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to search series: $e');
    }
  }

  Future<List<Comment>> getComments(int movieId) async {
    try {
      final response = await dio.get('/movie/$movieId/reviews');
      return (response.data['results'] as List)
          .map((json) => Comment.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to load comments: $e');
    }
  }

  Future<String> gettrailer(int movieId) async {
    try {
      final response = await dio.get('/movie/$movieId/videos');
      return _trailerUrl(response.data['results'] as List);
    } on DioException catch (e) {
      throw Exception('Failed to load trailer: $e');
    }
  }

  String _trailerUrl(List<dynamic> videos) {
    final trailer = videos.cast<Map<String, dynamic>>().firstWhere(
      (video) => video['site'] == 'YouTube' && video['type'] == 'Trailer',
      orElse: () => <String, dynamic>{},
    );
    final key = trailer['key'] as String?;
    if (key == null || key.isEmpty) {
      throw Exception('No trailer found');
    }
    return 'https://www.youtube.com/watch?v=$key';
  }
}
