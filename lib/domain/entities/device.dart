import 'package:cloud_firestore/cloud_firestore.dart';

class Device {
  final String? id;
  final String name;
  final String description;
  final String serialNumber;
  final DocumentReference userId;

  Device({
    this.id,
    required this.name,
    required this.description,
    required this.serialNumber,
    required this.userId
  });
}
