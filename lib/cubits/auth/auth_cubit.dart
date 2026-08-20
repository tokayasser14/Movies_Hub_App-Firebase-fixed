import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    if (email.isEmpty) {
      emit(AuthError('Please enter your email'));
      return;
    }
    if (!email.contains('@')) {
      emit(AuthError('Please enter a valid email'));
      return;
    }
    if (password.isEmpty) {
      emit(AuthError('Please enter your password'));
      return;
    }
    if (password.length < 6) {
      emit(AuthError('Password must be at least 6 characters'));
      return;
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (error) {
      emit(AuthError(_messageFor(error)));
    } catch (_) {
      emit(AuthError('Could not sign in. Please try again.'));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    emit(AuthLoading());
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });
      emit(AuthSuccess());
    } on FirebaseAuthException catch (error) {
      emit(AuthError(_messageFor(error)));
    } catch (_) {
      emit(AuthError('Could not create the account. Please try again.'));
    }
  }

  Future<void> signOut() => _auth.signOut();

  String _messageFor(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Incorrect email or password.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email.';
      default:
        return error.message ?? 'Authentication failed.';
    }
  }
}
