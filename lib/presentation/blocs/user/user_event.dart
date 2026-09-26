import 'package:equatable/equatable.dart';
import 'package:lumb/domain/entities/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class GetDocumentReferenceUserByIdEvent extends UserEvent {
  final String userId;

  const GetDocumentReferenceUserByIdEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SaveUserEvent extends UserEvent {
  final User user;

  const SaveUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}
