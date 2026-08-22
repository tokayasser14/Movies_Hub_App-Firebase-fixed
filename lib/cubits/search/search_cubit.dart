import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';
import 'package:movies_hub_app/models/movie.dart';
import 'package:movies_hub_app/models/movie_model.dart';

class SearchCubit extends Cubit<SearchState> {
  final Service _service = Service();

  SearchCubit() : super(SearchInitial());

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final List<Movie> movies = await _service.searchMovies(query);
      emit(SearchSuccess(movies));
    } catch (e) {
      emit(SearchError('Failed to fetch search results'));
    }
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}
