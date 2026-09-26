import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AnimateContainer extends StatelessWidget {
  final Widget content;
  final Widget view;
  final bool tappable;
  const AnimateContainer(
      {super.key,
      required this.content,
      this.tappable = true,
      required this.view});

  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 600),
      closedElevation: 0,
      openElevation: 0,
      openShape: _roundedShape,
      closedShape: _roundedShape,
      openBuilder: (BuildContext contexts, VoidCallback _) {
        return view;
      },
      tappable: tappable,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(10),
          child: content,
        );
      },
    );
  }

  RoundedRectangleBorder get _roundedShape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      );
}
