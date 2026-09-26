import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  const UserState({
    this.status = UserStatus.initial,
    this.documentReference,
    this.errorMessage,
  });

  final UserStatus status;
  final DocumentReference? documentReference;
  final String? errorMessage;

  UserState copyWith({
    UserStatus Function()? status,
    DocumentReference? Function()? documentReference,
    String? Function()? errorMessage,
  }) {
    return UserState(
      status: status != null ? status() : this.status,
      documentReference:
          documentReference != null ? documentReference() : this.documentReference,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, documentReference, errorMessage];
}
