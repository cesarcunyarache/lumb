import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumb/core/error/handle_firebase_exception.dart';
import 'package:lumb/data/models/user_model.dart';
import 'package:lumb/data/service/firebase_user_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseUserService _firebaseUserService = FirebaseUserService();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    
    } on FirebaseAuthException catch (e) {
      throw HandleFirebaseAuthException(e);
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

        await _firebaseUserService.saveUser(UserModel(
          displayName: "",
          email: userCredential.user!.email!,
          photoUrl: "",
          userId: userCredential.user!.uid));

    } on FirebaseAuthException catch (e) {
      throw HandleFirebaseAuthException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: ${e.toString()}');
    }
  }

  Future<void> sendRecoveryEmail({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw HandleFirebaseAuthException(e);
    }
  }

  Future<void> signInWithCredentials(AuthCredential credential) async {
    try {
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      await _firebaseUserService.saveUser(UserModel(
          displayName: userCredential.user!.displayName!,
          email: userCredential.user!.email!,
          photoUrl: userCredential.user!.photoURL!,
          userId: userCredential.user!.uid));

          
    } on FirebaseAuthException catch (e) {
      throw HandleFirebaseAuthException(e);
    }
  }

  Future<void> changeDisplayName(String displayName) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(displayName);
    } catch (e) {
      throw Exception('Error al cambiar el nombre de usuario: ${e.toString()}');
    }
  }

  Future<void> changeEmail(String email) async {
    try {
      await _firebaseAuth.currentUser?.updateEmail(email);
    } on FirebaseAuthException catch (e) {
      throw HandleFirebaseAuthException(e);
    }
  }

  Future<void> changePassword(String password) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(password);
    } on FirebaseAuthException catch (e) {
      throw HandleFirebaseAuthException(e);
    }
  }

  Future<void> changeProfilePhoto(String url) async {
    try {
      await _firebaseAuth.currentUser?.updatePhotoURL(url);
    } catch (e) {
      throw Exception('Error al actualizar la foto de perfil: ${e.toString()}');
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification(
        ActionCodeSettings(url: ""),
      );
    } on FirebaseAuthException catch (e) {
      throw HandleFirebaseAuthException(e);
    }
  }
}
