import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_hub_app/models/movie_model.dart';
import 'package:movies_hub_app/models/movie.dart'; 
part 'home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

 Future<void> fetchHomeMovies() async {
  emit(HomeLoading());

  try {
    final movies = await Service().getmovie();
    emit(
      HomeLoaded(
        popularMovies: movies,
        topRatedMovies: [],
      ),
    );
  } catch (e) {
    emit(HomeError(message: 'Failed to load movies. Please check your internet connection'));
  }
}
}
