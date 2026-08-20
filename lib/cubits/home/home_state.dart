part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List popularMovies;
  final List topRatedMovies;

  HomeLoaded({required this.popularMovies, required this.topRatedMovies});
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
