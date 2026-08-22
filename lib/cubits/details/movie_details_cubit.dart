import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_details_state.dart';
import '../../models/movie_model.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit() : super(MovieInitial());

  Future<void> getmovie() async {
    emit(MovieLoading());

    try {
      final movies = await Service().getmovie();
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> gettrailer(int movieId) async {
    emit(MovieLoading());

    try {
      final trailerUrl = await Service().gettrailer(movieId);
      emit(MovieTrailerLoaded(trailerUrl));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> getComments(int movieId) async {
    emit(MovieLoading());

    try {
      final comments = await Service().getComments(movieId);
      emit(MovieCommentsLoaded(comments));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }
}
