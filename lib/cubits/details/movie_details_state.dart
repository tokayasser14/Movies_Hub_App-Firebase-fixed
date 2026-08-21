import 'package:movies_hub_app/models/movie.dart';
import 'package:movies_hub_app/models/comment.dart';

class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;

  MovieLoaded(this.movies);
}

class MovieTrailerLoaded extends MovieState {
  final String trailerUrl;

  MovieTrailerLoaded(this.trailerUrl);
}

class MovieCommentsLoaded extends MovieState {
  final List<Comment> comments;

  MovieCommentsLoaded(this.comments);
}

class MovieError extends MovieState {
  final String message;

  MovieError(this.message);
}
