import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumb/data/models/device_model.dart';
import 'package:lumb/domain/entities/device.dart';

class FirebaseDeviceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final String _collectionPath = 'Devices';

  Future<void> addDevice(Device device) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .add(DeviceModel.fromEntity(device).toJson());
    } catch (e) {
      throw Exception('Error al agregar el dispositivo: ${e.toString()}');
    }
  }

  Stream<List<Device>> getDevices() {
    try {

       final userDocRef = _firestore.collection('Users').doc(_firebaseAuth.currentUser!.uid);
      return _firestore.collection(_collectionPath).where('userId', isEqualTo: userDocRef).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return DeviceModel.fromJson(doc.id, data);
        }).toList();
      });
    } catch (e) {
      throw Exception('Error al obtener los dispositivos: ${e.toString()}');
    }
  }

  Future<void> updateDevice(Device device) async {
    if (device.id == null) {
      throw Exception('El ID del dispositivo no puede ser nulo');
    }

    try {
      await _firestore
          .collection(_collectionPath)
          .doc(device.id)
          .update(DeviceModel.fromEntity(device).toJson());
    } catch (e) {
      throw Exception('Error al actualizar el dispositivo: ${e.toString()}');
    }
  }

  Future<void> deleteDevice(String id) async {
    try {
      await _firestore.collection('devices').doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar el dispositivo: ${e.toString()}');
    }
  }
}
