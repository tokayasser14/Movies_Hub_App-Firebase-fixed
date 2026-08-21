import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  Future<void> updateUserData({
    required String newName,
    required String newEmail,
    required String newPhone,
    required String newPassword,
  }) async {
    // 1. Validation Logic
    if (newName.isEmpty) {
      emit(EditProfileFailure('Please enter your username'));
      return;
    }

    if (newEmail.isEmpty) {
      emit(EditProfileFailure('Please enter your email'));
      return;
    }

    if (!newEmail.contains('@') || !newEmail.endsWith('.com')) {
      emit(EditProfileFailure('Please enter a valid email address'));
      return;
    }

    if (newPassword.isEmpty) {
      emit(EditProfileFailure('Please enter your password'));
      return;
    }

    if (newPhone.isEmpty) {
      emit(EditProfileFailure('Please enter your phone number'));
      return;
    }

    if (newName.length > 20) {
      emit(EditProfileFailure('user name must not exceed 20 characters.'));
      return;
    }

    if (newPhone.length != 11 ||
        (!newPhone.startsWith('011') &&
            !newPhone.startsWith('012') &&
            !newPhone.startsWith('015') &&
            !newPhone.startsWith('010'))) {
      emit(EditProfileFailure('Please Enter a Valid Phone Number'));
      return;
    }

    //Firebase
    emit(EditProfileLoading());

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      if (newEmail != user.email) {
        await user.verifyBeforeUpdateEmail(newEmail);
      }
      if (newPassword.isNotEmpty) await user.updatePassword(newPassword);
      await user.updateDisplayName(newName);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': newName,
        'email': newEmail,
        'phone': newPhone,
      }, SetOptions(merge: true));

      emit(EditProfileSuccess());
    } on FirebaseAuthException catch (error) {
      emit(
        EditProfileFailure(
          error.code == 'requires-recent-login'
              ? 'Please sign out and sign in again before changing email or password.'
              : error.message ?? 'Failed to update profile.',
        ),
      );
    } catch (_) {
      emit(EditProfileFailure('Failed to update profile.'));
    }
  }
}