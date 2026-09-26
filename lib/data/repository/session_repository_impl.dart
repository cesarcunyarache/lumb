import 'package:lumb/data/service/firebase_session_service.dart';
import 'package:lumb/domain/entities/session.dart';
import 'package:lumb/domain/repository/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final FirebaseSessionService _sessionService;

  SessionRepositoryImpl(this._sessionService);

  @override
  Future<void> addSession(Session session) async {
    await _sessionService.addSession(session);
  }

  @override
  Stream<List<Session>> getSessions() {
    return _sessionService.getSessions();
  }

  @override
  Future<void> updateSession(Session session) async {
    await _sessionService.updateSession(session);
  }

  @override
  Future<void> deleteSession(String id) async {
    await _sessionService.deleteSession(id);
  }
}
