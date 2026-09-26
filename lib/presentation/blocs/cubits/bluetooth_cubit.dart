import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothState {
  final bool isEnabled;
  final List<BluetoothDevice> bondedDevices;
  final BluetoothDevice? connectedDevice;
  final BluetoothConnection? connection;
  final int timesPressed;

  const BluetoothState({
    required this.isEnabled,
    required this.bondedDevices,
    required this.connectedDevice,
    required this.connection,
    required this.timesPressed,
  });

  BluetoothState copyWith({
    bool? isEnabled,
    List<BluetoothDevice>? bondedDevices,
    BluetoothDevice? connectedDevice,
    BluetoothConnection? connection,
    int? timesPressed,
  }) {
    return BluetoothState(
      isEnabled: isEnabled ?? this.isEnabled,
      bondedDevices: bondedDevices ?? this.bondedDevices,
      connectedDevice: connectedDevice,
      connection: connection ?? this.connection,
      timesPressed: timesPressed ?? this.timesPressed,
    );
  }
}

class BluetoothCubit extends Cubit<BluetoothState> {
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  BluetoothCubit()
      : super(const BluetoothState(
          isEnabled: false,
          bondedDevices: [],
          connectedDevice: null,
          connection: null,
          timesPressed: 0,
        )) {
    _initialize();
  }

  void _initialize() async {
    await _requestPermissions();
    final isEnabled = await _bluetooth.isEnabled;
    final bondedDevices = await _bluetooth.getBondedDevices();
    emit(state.copyWith(isEnabled: isEnabled, bondedDevices: bondedDevices));

    _bluetooth.onStateChanged().listen((event) {
      emit(state.copyWith(isEnabled: event.isEnabled));
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      final connection = await BluetoothConnection.toAddress(device.address);
      emit(state.copyWith(connectedDevice: device, connection: connection));
      connection.input?.listen((data) {
        if (String.fromCharCodes(data) == 'p') {
          emit(state.copyWith(timesPressed: state.timesPressed + 1));
        }
      });
    } catch (e) {
      print("Error connecting to device: $e");
    }
  }

  void disconnect() async {
    await state.connection?.finish();
    emit(state.copyWith(connectedDevice: null, connection: null));
  }

  void sendData(String data) {
    if (state.connection?.isConnected ?? false) {
      state.connection?.output.add(ascii.encode(data));
    }
  }
}
