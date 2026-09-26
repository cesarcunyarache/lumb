import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumb/domain/entities/device.dart';

class DeviceModel extends Device {
  DeviceModel(
      {super.id,
      required super.name,
      required super.description,
      required super.serialNumber,
      required super.userId});

  factory DeviceModel.fromJson(String id, Map<String, dynamic> json) {
    return DeviceModel(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String,
      serialNumber: json['serialNumber'] as String,
      userId: json['userId'] as DocumentReference,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'serialNumber': serialNumber,
    };
  }

  factory DeviceModel.fromEntity(Device device) {
    return DeviceModel(
      name: device.name,
      description: device.description,
      serialNumber: device.serialNumber,
      userId: device.userId
    );
  }
}
