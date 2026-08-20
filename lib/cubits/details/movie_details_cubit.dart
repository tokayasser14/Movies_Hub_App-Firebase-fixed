import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_details_state.dart';
import '../../models/movie.dart';
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
}
