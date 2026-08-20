import 'package:dio/dio.dart';
import 'movie.dart';

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
}
