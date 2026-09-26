import 'package:lumb/domain/entities/session.dart';

abstract class SessionRepository {

  Future<void> addSession(Session session);

  Stream<List<Session>> getSessions();

  Future<void> updateSession(Session session);

  Future<void> deleteSession(String id);
}
