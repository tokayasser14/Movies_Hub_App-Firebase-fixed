import 'package:flutter/foundation.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final String userName;
  final String email;
  final String phone;
  final String password;
  final List<dynamic> favouriteMovies;

  ProfileSuccess({
    required this.userName,
    required this.email,
    required this.phone,
    required this.password,
    required this.favouriteMovies,
  });

  ProfileSuccess copyWith({
    String? userName,
    String? email,
    String? phone,
    String? password,
    List<dynamic>? favouriteMovies,
  }) {
    return ProfileSuccess(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      favouriteMovies: favouriteMovies ?? this.favouriteMovies,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
