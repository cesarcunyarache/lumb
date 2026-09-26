import 'package:flutter/material.dart';
import 'package:lumb/config/colors/app_colors.dart';

class CustomFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color color;
  final double height;
  final double borderRadius;

  const CustomFilledButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.color = AppColors.primaryColor,
    this.height = 50.0,
    this.borderRadius = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return color.withOpacity(0.5); // Color tenue cuando está deshabilitado
          }
          return color;
        }),
        minimumSize: WidgetStateProperty.all(
          Size.fromHeight(height),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}