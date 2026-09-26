import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lumb/config/colors/app_colors.dart';
import 'package:lumb/config/common/app_text_styles.dart';
import 'package:lumb/config/common/text_style_ext.dart';

class RichTwoPartsText extends StatelessWidget {
  final String text1;
  final String text2;
  final VoidCallback onTap;
  const RichTwoPartsText({
    super.key,
    required this.text1,
    required this.text2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: context.tm!.copyWith(
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.normal),
        text: text1,
        children: [
          TextSpan(
            text: text2,
            style: const TextStyle(
                fontFamily: 'Roboto',
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  final Function(String?)? onSaved;
  const PasswordField({super.key, this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
      // cursorColor: isDark ? Colors.grey : Colors.black54,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blueGrey.withOpacity(.1),
        hintText: "***********",
        prefixIcon: const Icon(IconlyLight.lock, size: 20),
        suffixIcon: const Icon(IconlyLight.hide, size: 20),
        // prefixIconColor: isDark ? Colors.white : Colors.black87,
        // suffixIconColor: isDark ? Colors.white : Colors.black87,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  final Function(String?)? onSaved;

  const EmailField({super.key, this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
      // cursorColor: isDark ? Colors.grey : Colors.black54,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blueGrey.withOpacity(.1),
          hintText: "undefined@gmail.com",
          prefixIcon: const Icon(IconlyLight.message, size: 20),
          // prefixIconColor: isDark ? Colors.white : Colors.black87,
          /* border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ) */
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          )),
    );
  }
}
