import 'package:lumb/core/usecases/usecase.dart';
import 'package:lumb/domain/entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumb/domain/repository/user_repository.dart';


class GetDocumentReferenceUserByIdUseCase
    implements UseCase<DocumentReference, String> {
  final UserRepository _userRepository;

  GetDocumentReferenceUserByIdUseCase(this._userRepository);

  @override
  Future<DocumentReference> call({String? params}) {
    return _userRepository.getDocumentReferenceUserById(params!);
  }
}

class SaveUserUseCase implements UseCase<void, User> {
  final UserRepository _userRepository;

  SaveUserUseCase(this._userRepository);

  @override
  Future<void> call({User? params}) {
    return _userRepository.saveUser(params!);
  }
}
