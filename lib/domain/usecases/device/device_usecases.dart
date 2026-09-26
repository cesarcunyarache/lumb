import 'package:lumb/core/usecases/usecase.dart';
import 'package:lumb/domain/entities/device.dart';
import 'package:lumb/domain/repository/device_repository.dart';


class AddDeviceUseCase implements UseCase<void, Device> {
  final DeviceRepository _deviceRepository;

  AddDeviceUseCase(this._deviceRepository);

  @override
  Future<void> call({Device? params}) {
    return _deviceRepository.addDevice(params!);
  }
}

class GetDevicesUseCase implements SyncUseCase<Stream<List<Device>>, void> {
  final DeviceRepository _deviceRepository;

  GetDevicesUseCase(this._deviceRepository);

  @override
  Stream<List<Device>> call({void params}) {
    return _deviceRepository.getDevices();
  }
}


class UpdateDeviceUseCase implements UseCase<void, Device> {
  final DeviceRepository _deviceRepository;

  UpdateDeviceUseCase(this._deviceRepository);

  @override
  Future<void> call({Device? params}) {
    return _deviceRepository.updateDevice(params!);
  }
}

class DeleteDeviceUseCase implements UseCase<void, String> {
  final DeviceRepository _deviceRepository;

  DeleteDeviceUseCase(this._deviceRepository);

  @override
  Future<void> call({String? params}) {
    return _deviceRepository.deleteDevice(params!);
  }
}
