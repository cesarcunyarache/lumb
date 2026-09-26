import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumb/domain/entities/device.dart';
import 'package:lumb/domain/usecases/device/device_usecases.dart';

import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final AddDeviceUseCase _addDeviceUseCase;
  final GetDevicesUseCase _getDevicesUseCase;
  final UpdateDeviceUseCase _updateDeviceUseCase;
  final DeleteDeviceUseCase _deleteDeviceUseCase;

  DeviceBloc(
    this._addDeviceUseCase,
    this._getDevicesUseCase,
    this._updateDeviceUseCase,
    this._deleteDeviceUseCase,
  ) : super(const DeviceState()) {
    on<AddDeviceEvent>(_onAddDevice);
    on<GetDevicesEvent>(_onGetDevices);
    on<UpdateDeviceEvent>(_onUpdateDevice);
    on<DeleteDeviceEvent>(_onDeleteDevice);
  }

  Future<void> _onAddDevice(
      AddDeviceEvent event, Emitter<DeviceState> emit) async {
    emit(state.copyWith(status: () => DeviceStatus.loading));
    try {
      await _addDeviceUseCase(params: event.device);
      emit(state.copyWith(status: () => DeviceStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: () => DeviceStatus.failure,
          errorMessage: () => e.toString()));
    }
  }

  Future<void> _onGetDevices(
      GetDevicesEvent event, Emitter<DeviceState> emit) async {
    emit(state.copyWith(status: () => DeviceStatus.loading));
    try {
      final devicesStream = _getDevicesUseCase();
      await emit.forEach<List<Device>>(devicesStream, onData: (devices) {
        return state.copyWith(
            devices: () => devices, status: () => DeviceStatus.success);
      });
    } catch (e) {
      emit(state.copyWith(
          status: () => DeviceStatus.failure,
          errorMessage: () => e.toString()));
    }
  }

  Future<void> _onUpdateDevice(
      UpdateDeviceEvent event, Emitter<DeviceState> emit) async {
    try {
      await _updateDeviceUseCase(params: event.device);
      state.copyWith(status: () => DeviceStatus.success);
    } catch (e) {
      emit(state.copyWith(
          status: () => DeviceStatus.failure,
          errorMessage: () => e.toString()));
    }
  }

  Future<void> _onDeleteDevice(
      DeleteDeviceEvent event, Emitter<DeviceState> emit) async {
    emit(state.copyWith(status: () => DeviceStatus.loading));
    try {
      await _deleteDeviceUseCase(params: event.deviceId);
      state.copyWith(status: () => DeviceStatus.success);
    } catch (e) {
      emit(state.copyWith(
          status: () => DeviceStatus.failure,
          errorMessage: () => e.toString()));
    }
  }
}
