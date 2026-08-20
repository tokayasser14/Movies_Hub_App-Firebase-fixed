import 'package:flutter/foundation.dart';

@immutable
abstract class WatchlistState {}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistSuccess extends WatchlistState {
  final List<dynamic> movies;
  WatchlistSuccess(this.movies);
}

class WatchlistError extends WatchlistState {
  final String message;
  WatchlistError(this.message);
}
