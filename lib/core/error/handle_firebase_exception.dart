import 'package:firebase_auth/firebase_auth.dart';

class HandleFirebaseAuthException implements Exception {
  final FirebaseAuthException exception;

  HandleFirebaseAuthException(this.exception);

  @override
  String toString() {
    return _getErrorMessage();
  }

  String _getErrorMessage() {
    switch (exception.code) {
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada. Contacte soporte.';
      case 'user-not-found':
        return 'No se encontró una cuenta con este correo.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Este correo ya está en uso.';
      case 'operation-not-allowed':
        return 'Esta operación no está permitida.';
      case 'invalid-credential':
        return 'Credenciales inválidas.';
      default:
        return 'Ocurrió un error inesperado: ${exception.message}';
    }
  }
}