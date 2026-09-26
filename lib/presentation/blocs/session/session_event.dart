import 'package:equatable/equatable.dart';
import 'package:lumb/domain/entities/session.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class AddSessionEvent extends SessionEvent {
  final Session session;

  const AddSessionEvent(this.session);

  @override
  List<Object?> get props => [session];
}

class GetSessionsEvent extends SessionEvent {}

class UpdateSessionEvent extends SessionEvent {
  final Session session;

  const UpdateSessionEvent(this.session);

  @override
  List<Object?> get props => [session];
}

class DeleteSessionEvent extends SessionEvent {
  final String sessionId;

  const DeleteSessionEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}
