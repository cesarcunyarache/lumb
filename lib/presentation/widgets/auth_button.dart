import 'package:flutter/material.dart';
import 'package:lumb/config/colors/app_colors.dart';
import 'package:lumb/config/common/app_text_styles.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String text;
  const LoginButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
  });

  @override
Widget build(BuildContext context) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      backgroundColor: isDark ? AppColors.secundaryColorDark : const Color.fromARGB(179, 244, 249, 251),
      side: BorderSide(
        color: isDark
            ? const Color.fromARGB(179, 106, 106, 106)
            : const Color.fromARGB(255, 165, 165, 165),
        width: 0,
      ),
      fixedSize: const Size.fromHeight(50),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon, // Alineado a la izquierda
        const SizedBox(width: 10), // Espacio entre el icono y el texto
        Text(
          text,
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.normal,
            color: isDark ? AppColors.colorTextDart : AppColors.colorText,
          ),
        ),
      ],
    ),
  );
}

}
