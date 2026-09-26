import 'package:flutter/material.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:lumb/config/colors/app_colors.dart';

class ReactiveInputFieldObscure extends StatefulWidget {
  final String formControlName;
  final String label;
  final Map<String, String Function(Object)>? validationMessages;
  final bool obscureText;

  const ReactiveInputFieldObscure({
    super.key,
    required this.formControlName,
    required this.label,
    this.validationMessages,
    this.obscureText = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ReactiveInputFieldObscureState createState() =>
      _ReactiveInputFieldObscureState();
}

class _ReactiveInputFieldObscureState extends State<ReactiveInputFieldObscure> {
  late FocusNode _focusNode;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Listener para actualizar `hasError` al perder el foco
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          final control =
              // ignore: invalid_use_of_protected_member
              ReactiveForm.of(context)?.findControl(widget.formControlName);
          control?.markAsTouched();
          hasError = control?.invalid == true && control?.touched == true;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Escucha los cambios de valor del campo para actualizar `hasError`
    final control =
        // ignore: invalid_use_of_protected_member
        ReactiveForm.of(context)?.findControl(widget.formControlName);
    control?.valueChanges.listen((_) {
      setState(() {
        hasError = control.invalid && control.touched;
      });
    });

    // Escuchar los cambios en el campo de confirmación si este es el de contraseña
    if (widget.formControlName == 'passwordConfirmation') {
      // ignore: invalid_use_of_protected_member
      final passwordControl = ReactiveForm.of(context)?.findControl('password');
      passwordControl?.valueChanges.listen((_) {
        setState(() {
          hasError = control!.invalid && control.touched;
        });
      });
    }
  }

  /*  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  } */

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiqueta
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
            color: hasError ? Colors.red : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        // Campo de entrada
        ReactiveTextField(
          formControlName: widget.formControlName,
          focusNode: _focusNode,
          validationMessages: widget.validationMessages,
          obscureText: _obscureText,
          obscuringCharacter: '•',
          cursorHeight: 20,
          style:  TextStyle(
            fontSize: _obscureText ? 20 : 16, // Tamaño del texto que el usuario escribe en el input
            fontWeight: _obscureText ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Roboto',
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFFA4BAD9), width: 2),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 189, 189, 189), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 2,
                color: AppColors.primaryColor,
              ),
            ),
            fillColor: const Color.fromARGB(255, 247, 247, 247),
            filled: true,
            errorStyle: const TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          ),
          showErrors: (control) => control.touched,
        ),
      ],
    );
  }
}
