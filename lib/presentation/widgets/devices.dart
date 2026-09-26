import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumb/config/colors/app_colors.dart';
import 'package:lumb/domain/entities/device.dart';
import 'package:lumb/presentation/screen/control_panel/control_panel_page.dart';
import 'package:lumb/presentation/screen/home/views/edit_device.dart';

class Devices extends StatefulWidget {
  final Device device;
  final IconData icon;

  const Devices({
    super.key,
    required this.device,
    required this.icon,
  });

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
   bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 600),
      closedElevation: 0,
      openElevation: 0,
      openShape: _roundedShape,
      closedShape: _roundedShape,
      openBuilder: (BuildContext context, VoidCallback _) {

       /* BlocProvider.of<SessionCubit>(context).updateTime(minutes: 0, seconds: 30,); */
     

        return ControlPanelPage(tag: widget.device.name);
      },
      tappable: widget.device.name == widget.device.name,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: _buildContainerDecoration(),
          padding: const EdgeInsets.all(10),
          child: _buildContent(context),
        );
      },
    );
  }

  RoundedRectangleBorder get _roundedShape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      );

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      border: Border.all(
        color: Colors.grey[300]!,
        width: 0.6,
      ),
      color: isActive ? AppColors.primaryColor : Colors.white,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHeader(context),
        _buildSwitch(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(widget.icon, color: isActive ? Colors.white : Colors.black, size: 40),
            IconButton(
                onPressed: () {

                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    showDragHandle: true,
                      context: context,
                      builder: (build) {
                        return EditDevice(device: widget.device);
                      });
                },
                icon: Icon(Icons.more_vert, color: Colors.grey[300]!))
          ],
        ),
        const SizedBox(height: 14),
        _buildDeviceName(),
      ],
    );
  }

  Widget _buildDeviceName() {
    return SizedBox(
      width: 65,
      child: Text(
        widget.device.name,
        style: TextStyle(
          height: 1.2,
          fontSize: 14,
          color: isActive ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSwitch() {
    return Transform.scale(
      alignment: Alignment.center,
      scaleY: 0.8,
      scaleX: 0.85,
      child: CupertinoSwitch(
        onChanged: (value) => setState(() => isActive = value),
        value: isActive,
        activeColor: isActive ? Colors.white.withOpacity(0.4) : Colors.black,
        trackColor: Colors.black,
      ),
    );
  }
}
