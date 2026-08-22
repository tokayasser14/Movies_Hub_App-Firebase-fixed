part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
 final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;

  HomeLoaded({required this.popularMovies, required this.topRatedMovies});
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
