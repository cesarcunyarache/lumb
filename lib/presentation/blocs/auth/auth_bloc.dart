
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lumb/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:lumb/domain/usecases/auth/send_recovery_email_usecase.dart';
import 'package:lumb/domain/usecases/auth/signin_facebook_usecase.dart';
import 'package:lumb/domain/usecases/auth/signing_google_usecase.dart';

import '../../../domain/usecases/auth/signin_email_password.dart';
import '../../../domain/usecases/auth/signout.dart';
import '../../../domain/usecases/auth/signup_email_password.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailAndPasswordUseCase _signInWithEmailAndPasswordUseCase;
  final SignUpWithEmailAndPasswordUseCase _signUpWithEmailAndPasswordUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SendRecoveryEmailUseCase _sendRecoveryEmailUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithFacebookUseCase _signInWithFacebookUseCase;

  AuthBloc(
    this._signInWithEmailAndPasswordUseCase,
    this._signUpWithEmailAndPasswordUseCase,
    this._signOutUseCase,
    this._getCurrentUserUseCase,
    this._sendRecoveryEmailUseCase,
    this._signInWithGoogleUseCase,
    this._signInWithFacebookUseCase,
  ) : super(const LoadedAuthState()) {
    on<SignInEmailPasswordAuthEvent>(_onSignInEmailPassword);
    on<SignUpEmailPasswordAuthEvent>(_onSignUpEmailPassword);
    on<SignOutAuthEvent>(_onSignOut);
    on<SendRecoveryEmailAuthEvent>(_onSendRecoveryEmail);
    on<SignInWithGoogleAuthEvent>(_onSignInWithGoogle);
    on<SignInWithFacebookAuthEvent>(_onSignInWithFacebook);
  }

  _onSignInEmailPassword(
      SignInEmailPasswordAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      await _signInWithEmailAndPasswordUseCase(params: {
        'email': event.email,
        'password': event.password,
      });
      emit(const LoadedAuthState());
      /* Navigator.pushReplacementNamed(
        event.context,
        '/home',
      ); */
      event.context.pushNamed('/home');
    } catch (e) {
      emit(const LoadedAuthState());
      ScaffoldMessenger.of(event.context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _onSignInWithGoogle(
      SignInWithGoogleAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      await _signInWithGoogleUseCase();
      emit(const LoadedAuthState());
      /* Navigator.pushReplacementNamed(
        event.context,
        HomeScreen.routeName,
      ); */
      event.context.pushNamed('/home');
    } catch ( e) {
      emit(const LoadedAuthState());

      ScaffoldMessenger.of(event.context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _onSignInWithFacebook(
      SignInWithFacebookAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      await _signInWithFacebookUseCase();
      emit(const LoadedAuthState());
      /* Navigator.pushReplacementNamed(
        event.context,
        HomeScreen.routeName,
      ); */
      event.context.pushNamed('/home');
    } catch (e) {
      emit(const LoadedAuthState());
      ScaffoldMessenger.of(event.context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _onSignUpEmailPassword(
      SignUpEmailPasswordAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      await _signUpWithEmailAndPasswordUseCase(params: {
        'email': event.email,
        'password': event.password,
      });
      emit(const LoadedAuthState());
      /* Navigator.pushReplacementNamed(
        event.context,
        '/home',
      ); */

      // ignore: use_build_context_synchronously
      event.context.pushNamed('/home');
    } catch (e) {
      emit(const LoadedAuthState());
      ScaffoldMessenger.of(event.context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _onSignOut(SignOutAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      await _signOutUseCase();
      emit(const LoadedAuthState());

      event.context.pushNamed('/getStarted');
      /* Navigator.pushReplacementNamed(
        event.context,
        LoginScreen.routeName,
      ); */
    } catch (e) {
      emit(const LoadedAuthState());
      ScaffoldMessenger.of(event.context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  _onSendRecoveryEmail(
      SendRecoveryEmailAuthEvent event, Emitter<AuthState> emit) async {
    emit(const LoadingAuthState());
    try {
      await _sendRecoveryEmailUseCase(
        params: event.email,
      );
      emit(const LoadedAuthState());
      ScaffoldMessenger.of(event.context)
          .showSnackBar(const SnackBar(content: Text('Recovery email sent!')));
    } catch (e) {
      emit(const LoadedAuthState());
      ScaffoldMessenger.of(event.context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  User? getCurrentUser() {
    return _getCurrentUserUseCase();
  }
}
