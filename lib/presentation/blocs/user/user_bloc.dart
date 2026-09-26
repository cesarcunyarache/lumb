import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumb/domain/usecases/user/user_usecases.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetDocumentReferenceUserByIdUseCase _getDocumentReferenceUserByIdUseCase;
  final SaveUserUseCase _saveUserUseCase;

  UserBloc(
    this._getDocumentReferenceUserByIdUseCase,
    this._saveUserUseCase,
  ) : super(const UserState()) {
    on<GetDocumentReferenceUserByIdEvent>(_onGetDocumentReferenceUserById);
    on<SaveUserEvent>(_onSaveUser);
  }

  Future<void> _onGetDocumentReferenceUserById(
      GetDocumentReferenceUserByIdEvent event,
      Emitter<UserState> emit) async {
    emit(state.copyWith(status: () => UserStatus.loading));
    try {
      final documentReference = await _getDocumentReferenceUserByIdUseCase(
        params: event.userId,
      );
      emit(state.copyWith(
        documentReference: () => documentReference,
        status: () => UserStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: () => UserStatus.failure,
        errorMessage: () => e.toString(),
      ));
    }
  }

  Future<void> _onSaveUser(SaveUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: () => UserStatus.loading));
    try {
      await _saveUserUseCase(params: event.user);
      emit(state.copyWith(status: () => UserStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: () => UserStatus.failure,
        errorMessage: () => e.toString(),
      ));
    }
  }
}
