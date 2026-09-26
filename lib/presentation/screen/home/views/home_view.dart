import 'package:flutter/material.dart';

import 'package:lumb/config/colors/app_colors.dart';
import 'package:lumb/config/common/app_assets.dart';

import 'package:lumb/presentation/screen/home/views/bluetooth_view.dart';
import 'package:lumb/presentation/screen/home/widgets/device_container.dart';
import 'package:lumb/presentation/screen/home/widgets/session_container.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const DeviceContainer(),
              const SessionContainer(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToBluetoothView(context),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lumb",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            Text(
              "IoT",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          child: Image.asset(AppAssets.icon),
        ),
      ],
    );
  }

  void _navigateToBluetoothView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BluetoothView()),
    );
  }
}
