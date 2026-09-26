/* import 'package:equatable/equatable.dart';
import 'package:lumb/domain/entities/device.dart';

abstract class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object?> get props => [];
}

class DeviceInitial extends DeviceState {}

class DeviceLoading extends DeviceState {}

class DeviceLoaded extends DeviceState {
  final List<Device> devices;

  const DeviceLoaded(this.devices);

  @override
  List<Object?> get props => [devices];
}

class DeviceSuccess extends DeviceState {}

class DeviceError extends DeviceState {
  final String error;

  const DeviceError(this.error);

  @override
  List<Object?> get props => [error];
}
 */


import 'package:equatable/equatable.dart';
import 'package:lumb/domain/entities/device.dart';

enum DeviceStatus { initial, loading, success, failure }

class DeviceState extends Equatable {
  const DeviceState({
    this.status = DeviceStatus.initial,
    this.devices = const [],
    this.errorMessage,
  });

  final DeviceStatus status;
  final List<Device> devices;
  final String? errorMessage;

  DeviceState copyWith({
    DeviceStatus Function()? status,
    List<Device> Function()? devices,
    String? Function()? errorMessage,
  }) {
    return DeviceState(
      status: status != null ? status() : this.status,
      devices: devices != null ? devices() : this.devices,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, devices, errorMessage];
}
