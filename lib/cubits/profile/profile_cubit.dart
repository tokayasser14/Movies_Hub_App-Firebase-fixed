import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/movie.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _favoritesSubscription;
  List<Movie> _favoriteMovies = [];

  void fetchProfileData() {
    _userSubscription?.cancel();
    _favoritesSubscription?.cancel();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(ProfileInitial());
      return;
    }
    emit(ProfileLoading());
    final document = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    _userSubscription = document.snapshots().listen((snapshot) {
      final data = snapshot.data() ?? {};
      emit(
        ProfileSuccess(
          userName: data['name'] as String? ?? user.displayName ?? 'User',
          email: data['email'] as String? ?? user.email ?? '',
          phone: data['phone'] as String? ?? '',
          password: '',
          favouriteMovies: List.unmodifiable(_favoriteMovies),
        ),
      );
    }, onError: (_) => emit(ProfileError('Failed to load profile data.')));

    _favoritesSubscription = document
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
      _favoriteMovies = snapshot.docs
          .map((doc) => Movie.fromMap(doc.data()))
          .toList();
      final current = state;
      if (current is ProfileSuccess) {
        emit(
          current.copyWith(
            favouriteMovies: List.unmodifiable(_favoriteMovies),
          ),
        );
      }
    });
  }

  bool isFavorite(Movie movie) {
    return _favoriteMovies.any((item) => item.id == movie.id);
  }

  Future<void> addToFavorites(Movie movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(movie.id.toString())
        .set(movie.toMap());
  }

  Future<void> removeFromFavorites(Movie movie) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(movie.id.toString())
          .delete();
    } catch (_) {
      emit(ProfileError('Failed to remove movie from favorites.'));
    }
  }

  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie)) {
      await removeFromFavorites(movie);
    } else {
      await addToFavorites(movie);
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    _favoritesSubscription?.cancel();
    return super.close();
  }
}