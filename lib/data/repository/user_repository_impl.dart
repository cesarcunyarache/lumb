import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumb/data/service/firebase_user_service.dart';
import 'package:lumb/domain/entities/user.dart';
import 'package:lumb/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseUserService userService;

  UserRepositoryImpl(this.userService);

  @override
  Future<DocumentReference<Object?>> getDocumentReferenceUserById(String userId) async {
    return await userService.getDocumentReferenceUserById(userId);
  }

  @override
  Future<void> saveUser(User user) async {
    return await userService.saveUser(user);
  }
}
