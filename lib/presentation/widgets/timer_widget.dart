import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TimerWidget extends StatefulWidget {
  final int minutes;
  final int seconds;
  final bool isWorking;
  final int percent;
  final int minutesInSec;
  final Color? activeColor;

  const TimerWidget({
    super.key,
    required this.minutes,
    required this.seconds,
    required this.isWorking,
    required this.percent,
    required this.minutesInSec,
    this.activeColor,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late double safePercent;
  bool isResetting = false;

  @override
  void initState() {
    super.initState();
    safePercent = 0.0;
  }

  @override
  void didUpdateWidget(TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    
    double newPercent = (widget.percent / widget.minutesInSec).clamp(0.0, 1.0);

  
    if (widget.percent >= widget.minutesInSec && !isResetting) {
      setState(() {
        safePercent = 1.0; 
        isResetting = true;
      });

    
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            safePercent = 0.0; 
            isResetting = false; 
          });
        }
      });
    } else {
    
      setState(() {
        safePercent = newPercent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: CircularPercentIndicator(
        radius: 150,
        lineWidth: 8,
        percent: safePercent,
        animation: true,
        progressColor: widget.isWorking ? widget.activeColor ?? Colors.blue : Colors.green,
        backgroundColor: Colors.white,
        animateFromLastPercent: true,
        animationDuration: 500,
        widgetIndicator: Icon(
          Icons.circle,
          color: widget.isWorking ? widget.activeColor ?? Colors.blue : Colors.greenAccent,
        ),
        center: Text(
          '${_formatTime(widget.minutes)} : ${_formatTime(widget.seconds)}',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }
}
