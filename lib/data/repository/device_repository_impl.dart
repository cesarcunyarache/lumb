import 'package:lumb/data/service/firebase_device_service.dart';
import 'package:lumb/domain/entities/device.dart';
import 'package:lumb/domain/repository/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final FirebaseDeviceService _deviceService;

  DeviceRepositoryImpl(this._deviceService);

  @override
  Future<void> addDevice(Device device) async {
    await _deviceService.addDevice(device);
  }

  @override
  Stream<List<Device>> getDevices() {
    return _deviceService.getDevices();
  }

  @override
  Future<void> updateDevice(Device device) async {
    await _deviceService.updateDevice(device);
  }

  @override
  Future<void> deleteDevice(String id) async {
    await _deviceService.deleteDevice(id);
  }
}
