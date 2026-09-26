import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumb/data/models/user_model.dart';
import 'package:lumb/domain/entities/user.dart';

class FirebaseUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'Users';

  Future<DocumentReference> getDocumentReferenceUserById(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collectionPath).doc(userId).get();
      return doc.reference;
    } catch (e) {
      throw Exception('Error al obtener el usuario: ${e.toString()}');
    }
  }

  Future<void> saveUser(User user) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(user.userId)
          .set(UserModel.fromEntity(user).toJson());
    } catch (e) {
      print('Error al guardar el usuario: ${e.toString()}');
      throw Exception('Error al guardar el usuario: ${e.toString()}');
    }
  }
}
