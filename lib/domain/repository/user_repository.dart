import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumb/domain/entities/user.dart';

abstract class UserRepository {

  Future<DocumentReference> getDocumentReferenceUserById(String userId);

  Future<void> saveUser(User user);

}
