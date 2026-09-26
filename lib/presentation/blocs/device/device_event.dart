import 'package:equatable/equatable.dart';
import 'package:lumb/domain/entities/device.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object?> get props => [];
}

class AddDeviceEvent extends DeviceEvent {
  final Device device;

  const AddDeviceEvent(this.device);

  @override
  List<Object?> get props => [device];
}

class GetDevicesEvent extends DeviceEvent {}

class UpdateDeviceEvent extends DeviceEvent {
  final Device device;

  const UpdateDeviceEvent(this.device);

  @override
  List<Object?> get props => [device];
}

class DeleteDeviceEvent extends DeviceEvent {
  final String deviceId;

  const DeleteDeviceEvent(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}
