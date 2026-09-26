import 'package:lumb/core/usecases/usecase.dart';
import 'package:lumb/domain/entities/session.dart';
import 'package:lumb/domain/repository/session_repository.dart';

class AddSessionUseCase implements UseCase<void, Session> {
  final SessionRepository _sessionRepository;

  AddSessionUseCase(this._sessionRepository);

  @override
  Future<void> call({Session? params}) {
    return _sessionRepository.addSession(params!);
  }
}

class GetSessionsUseCase implements SyncUseCase<Stream<List<Session>>, void> {
  final SessionRepository _sessionRepository;

  GetSessionsUseCase(this._sessionRepository);

  @override
  Stream<List<Session>> call({void params}) {
    return _sessionRepository.getSessions();
  }
}

class UpdateSessionUseCase implements UseCase<void, Session> {
  final SessionRepository _sessionRepository;

  UpdateSessionUseCase(this._sessionRepository);

  @override
  Future<void> call({Session? params}) {
    return _sessionRepository.updateSession(params!);
  }
}

class DeleteSessionUseCase implements UseCase<void, String> {
  final SessionRepository _sessionRepository;

  DeleteSessionUseCase(this._sessionRepository);

  @override
  Future<void> call({String? params}) {
    return _sessionRepository.deleteSession(params!);
  }
}
