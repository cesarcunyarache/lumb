import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumb/domain/entities/session.dart';

import 'package:lumb/domain/usecases/session/session_usecases.dart';
import 'package:lumb/presentation/blocs/session/session_event.dart';
import 'package:lumb/presentation/blocs/session/session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final AddSessionUseCase _addSessionUseCase;
  final GetSessionsUseCase _getSessionsUseCase;
  final UpdateSessionUseCase _updateSessionUseCase;
  final DeleteSessionUseCase _deleteSessionUseCase;

  SessionBloc(
    this._addSessionUseCase,
    this._getSessionsUseCase,
    this._updateSessionUseCase,
    this._deleteSessionUseCase,
  ) : super(const SessionState()) {
    on<AddSessionEvent>(_onAddSession);
    on<GetSessionsEvent>(_onGetSessions);
    on<UpdateSessionEvent>(_onUpdateSession);
    on<DeleteSessionEvent>(_onDeleteSession);
  }

  Future<void> _onAddSession(
      AddSessionEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith(status: () => SessionBlocStatus.loading));
    try {
      await _addSessionUseCase(params: event.session);
      emit(state.copyWith(status: () => SessionBlocStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: () => SessionBlocStatus.failure,
          errorMessage: () => e.toString()));
    }
  }

  Future<void> _onGetSessions(
      GetSessionsEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith(status: () => SessionBlocStatus.loading));
    try {
      final sessionsStream = _getSessionsUseCase();
      await emit.forEach<List<Session>>(sessionsStream, onData: (sessions) {
        return state.copyWith(
            sessions: () => sessions, status: () => SessionBlocStatus.success);
      });
    } catch (e) {
      emit(state.copyWith(
          status: () => SessionBlocStatus.failure,
          errorMessage: () => e.toString()));
    }
  }

  Future<void> _onUpdateSession(
      UpdateSessionEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith(status: () => SessionBlocStatus.loading));
    try {
      await _updateSessionUseCase(params: event.session);
      emit(state.copyWith(status: () => SessionBlocStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: () => SessionBlocStatus.failure,
          errorMessage: () => e.toString()));
    }
  }

  Future<void> _onDeleteSession(
      DeleteSessionEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith(status: () => SessionBlocStatus.loading));
    try {
      await _deleteSessionUseCase(params: event.sessionId);
      emit(state.copyWith(status: () => SessionBlocStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: () => SessionBlocStatus.failure,
          errorMessage: () => e.toString()));
    }
  }
}
