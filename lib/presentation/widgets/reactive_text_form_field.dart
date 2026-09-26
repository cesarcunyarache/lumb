import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:lumb/config/colors/app_colors.dart';

class ReactiveInputField extends StatefulWidget {
  final String formControlName;
  final String label;
  final Map<String, String Function(Object)>? validationMessages;
  final TextInputType? keyboardType;
  final bool disable;

  const ReactiveInputField(
      {super.key,
      required this.formControlName,
      required this.label,
      this.validationMessages,
      this.keyboardType,
      this.disable = false});
    

  @override
  // ignore: library_private_types_in_public_api
  _ReactiveInputFieldState createState() => _ReactiveInputFieldState();
}

class _ReactiveInputFieldState extends State<ReactiveInputField> {
  late FocusNode _focusNode;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Add listener to update `hasError` on losing focus
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          // ignore: invalid_use_of_protected_member
          final control =
              // ignore: invalid_use_of_protected_member
              ReactiveForm.of(context)!.findControl(widget.formControlName);
          control?.markAsTouched();
          hasError = control?.invalid == true && control?.touched == true;
        });
      }
    });
  }

  /* @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
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
        // Input Field
        ReactiveTextField( 
          readOnly: widget.disable,
          enableInteractiveSelection: widget.disable,
          
          keyboardType: widget.keyboardType,
          formControlName: widget.formControlName,
          focusNode: _focusNode,
          validationMessages: widget.validationMessages,
          onChanged: (value) => {
            setState(() {
              final control =
                  // ignore: invalid_use_of_protected_member
                  ReactiveForm.of(context)!.findControl(widget.formControlName);
              control?.markAsTouched();
              hasError = control?.invalid == true && control?.touched == true;
            })
          },
          cursorHeight: 20,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
           
          ),
          decoration: InputDecoration(
            
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
             contentPadding: const EdgeInsets.symmetric(vertical:0, horizontal: 15), 
          ),
          showErrors: (control) => control.touched,
        ),
      ],
    );
  }
}
