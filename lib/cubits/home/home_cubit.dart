import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_hub_app/models/movie.dart';
import 'package:movies_hub_app/models/movie_model.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> fetchHomeMovies() async {
    emit(HomeLoading());

    try {
      final movies = await Service().getmovie();
      emit(
        HomeLoaded(
          popularMovies: movies
              .map(
                (movie) => {
                  'id': movie.id,
                  'title': movie.name,
                  'overview': movie.description,
                  'posterPath': movie.posterPath.isNotEmpty
                      ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                      : '',
                  'rating': movie.rating,
                  'releaseDate': movie.ReleaseDate,
                },
              )
              .toList(),
          topRatedMovies: [],
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
