import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumb/data/models/session_model.dart';
import 'package:lumb/domain/entities/session.dart';

class FirebaseSessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final String _collectionPath = 'Sessions';

  Future<void> addSession(Session session) async {
    try {
      final userDocRef =
          _firestore.collection('Users').doc(_firebaseAuth.currentUser!.uid);
      session.userId = userDocRef;

      await _firestore
          .collection(_collectionPath)
          .add(SessionModel.fromEntity(session).toJson());
    } catch (e) {
      throw Exception('Error al agregar la sesión: ${e.toString()}');
    }
  }

  Stream<List<Session>> getSessions() {
    try {
      final userDocRef =
          _firestore.collection('Users').doc(_firebaseAuth.currentUser!.uid);
      return _firestore
          .collection(_collectionPath)
          .where('userId', isEqualTo: userDocRef)
          .orderBy('date', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();

          return SessionModel.fromJson(doc.id, data);
        }).toList();
      });
    } catch (e) {
      throw Exception('Error al obtener las sesiones: ${e.toString()}');
    }
  }

  Future<void> updateSession(Session session) async {
    final userDocRef =
        _firestore.collection('Users').doc(_firebaseAuth.currentUser!.uid);

    session.userId = userDocRef;
    if (session.id.isEmpty) {
      throw Exception('El ID de la sesión no puede estar vacío');
    }
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(session.id)
          .update(SessionModel.fromEntity(session).toJson());
    } catch (e) {
      throw Exception('Error al actualizar la sesión: ${e.toString()}');
    }
  }

  Future<void> deleteSession(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar la sesión: ${e.toString()}');
    }
  }
}
