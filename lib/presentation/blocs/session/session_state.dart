import 'package:equatable/equatable.dart';
import 'package:lumb/domain/entities/session.dart';

enum SessionBlocStatus { initial, loading, success, failure }

class SessionState extends Equatable {
  const SessionState({
    this.status = SessionBlocStatus.initial,
    this.sessions = const [],
    this.errorMessage,
  });

  final SessionBlocStatus status;
  final List<Session> sessions;
  final String? errorMessage;

  SessionState copyWith({
    SessionBlocStatus Function()? status,
    List<Session> Function()? sessions,
    String? Function()? errorMessage,
  }) {
    return SessionState(
      status: status != null ? status() : this.status,
      sessions: sessions != null ? sessions() : this.sessions,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sessions, errorMessage];
}
