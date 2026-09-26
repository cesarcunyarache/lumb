import 'package:lumb/domain/entities/device.dart';

abstract class DeviceRepository {

  Future<void> addDevice(Device device);

  Stream<List<Device>> getDevices();

  Future<void> updateDevice(Device device);

  Future<void> deleteDevice(String id);

}
