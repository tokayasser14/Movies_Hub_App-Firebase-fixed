import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/movie.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit() : super(WatchlistInitial());

  final List<Movie> _watchlistMovies = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  List<Movie> get watchlistMovies => List.unmodifiable(_watchlistMovies);

  void fetchWatchlist() {
    _subscription?.cancel();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _watchlistMovies.clear();
      emit(WatchlistSuccess(const []));
      return;
    }
    _subscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .snapshots()
        .listen((snapshot) {
          _watchlistMovies
            ..clear()
            ..addAll(snapshot.docs.map((doc) => Movie.fromMap(doc.data())));
          emit(WatchlistSuccess(List.from(_watchlistMovies)));
        }, onError: (_) => emit(WatchlistError('Failed to load favourites.')));
  }

  bool isBookmarked(Movie movie) {
    return _watchlistMovies.any((item) => item.id == movie.id);
  }

  Future<void> addToWatchlist(Movie movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(WatchlistError('Please sign in to add favourites.'));
      return;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .doc(movie.id.toString())
        .set(movie.toMap());
  }

  Future<void> removeFromWatchlist(Movie movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .doc(movie.id.toString())
        .delete();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
