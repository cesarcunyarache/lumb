import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lumb/data/service/firebase_auth_service.dart';
import 'package:lumb/data/service/firebase_storage_service.dart';
import 'package:lumb/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _authService;
  final FirebaseStorageService _storageService;

  const AuthRepositoryImpl(this._authService, this._storageService);

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await _authService.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _authService.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  bool isLoggedIn() {
    return _authService.currentUser != null;
  }

  @override
  User? getCurrentUser() {
    return _authService.currentUser;
  }

  @override
  Future<void> sendRecoveryEmail(String email) {
    return _authService.sendRecoveryEmail(email: email);
  }

  @override
  Future<void> signIngWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(
      loginResult.accessToken!.tokenString,
    );

    return _authService.signInWithCredentials(facebookAuthCredential);
  }

  @override
  Future<void> signIngWithGoogle() async {

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await _authService.signInWithCredentials(credential);
  }

  @override
  Future<void> changeDisplayName(String displayName) {
    return _authService.changeDisplayName(displayName);
  }

  @override
  Future<void> changeEmail(String email) {
    return _authService.changeEmail(email);
  }

  @override
  Future<void> changePassword(String password) {
    return _authService.changePassword(password);
  }

  @override
  Future<void> sendVerifyEmail() {
    return _authService.sendVerificationEmail();
  }

  @override
  Future<void> saveProfilePhoto(File photo) async {
    final downloadUrl = await _storageService.uploadProfilePhoto(
        photo, _authService.currentUser!);
    await _authService.changeProfilePhoto(downloadUrl);
  }
}
