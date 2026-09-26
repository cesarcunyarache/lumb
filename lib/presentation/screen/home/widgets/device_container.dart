import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumb/presentation/blocs/device/device_bloc.dart';
import 'package:lumb/presentation/blocs/device/device_event.dart';
import 'package:lumb/presentation/blocs/device/device_state.dart';
import 'package:lumb/presentation/blocs/session/session_bloc.dart';
import 'package:lumb/presentation/blocs/session/session_event.dart';
import 'package:lumb/presentation/widgets/devices.dart';
import 'package:material_symbols_icons/symbols.dart';

class DeviceContainer extends StatefulWidget {
  const DeviceContainer({super.key});

  @override
  State<DeviceContainer> createState() => _DeviceContainerState();
}

class _DeviceContainerState extends State<DeviceContainer> {

  @override
  void initState() {
    super.initState();
    context.read<DeviceBloc>().add(GetDevicesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeviceBloc, DeviceState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(state),
              const SizedBox(height: 10),
              _buildContent(state),
            ],
          ),
        );
      },
    );
  }

  // Construye el encabezado
  Widget _buildHeader(DeviceState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getDeviceCountText(state),
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Text(
              "Dispositivos",
              style: TextStyle(
                height: 1.1,
                fontSize: 17,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Icon(
          Icons.more_horiz,
          color: Colors.grey[300],
          size: 30,
        ),
      ],
    );
  }

  String _getDeviceCountText(DeviceState state) {
    if (state.status == DeviceStatus.loading ||
        state.status == DeviceStatus.initial) {
      return "";
    }
    return "En total ${state.devices.length} dispositivos";
  }

  Widget _buildContent(DeviceState state) {
    switch (state.status) {
      case DeviceStatus.loading:
      case DeviceStatus.initial:
        return _buildLoadingIndicator();
      case DeviceStatus.success:
        if (state.devices.isEmpty) {
          return _buildEmptyState();
        }
        
        return _buildDeviceGrid(state);

      default:
        return _buildErrorState(state.errorMessage);
    }
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(strokeWidth: 3),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      child: const Center(
        child: Text(
          "No hay dispositivos disponibles.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildErrorState(String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text(
            errorMessage ?? "Ocurrió un error al cargar los dispositivos.",
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<SessionBloc>().add(GetSessionsEvent());
            },
            child: const Text("Reintentar"),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceGrid(DeviceState state) {
  return Wrap(
    spacing: 20,
    runSpacing: 20,
    children: state.devices.asMap().entries.map((entry) {
      final index = entry.key;
      final device = entry.value; 

      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.43,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Devices(
          device: device,
          icon: _icons[index % _icons.length], 
          
        ),
      );
    }).toList(),
  );
}

  List<IconData> get _icons => [
        Symbols.lightning_stand,
        Symbols.home_max_dots,
        Symbols.nest_wifi_router,
        Symbols.nest_wifi_point,
        Icons.home_max_outlined,
      ];
}
