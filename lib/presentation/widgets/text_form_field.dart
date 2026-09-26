import 'package:flutter/material.dart';
import 'package:lumb/config/colors/app_colors.dart';

class TextFormFieldCustom extends StatefulWidget {
  final String? label;
  final void Function(String?)? onSave;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final bool obscureText;

  const TextFormFieldCustom({
    super.key,
    this.label,
    this.onSave,
    this.textEditingController,
    this.textInputType,
    this.obscureText = false,
    this.validator,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TextFormFieldCustomState createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  late FocusNode _focusNode;
  // ignore: unused_field
  bool _isFocused = false;
  // ignore: unused_field
  bool _hasError = false;
  bool _userInteracted = false;
  TextEditingController? _internalController;

  TextEditingController get _controller =>
      widget.textEditingController ?? _internalController!;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    if (widget.textEditingController == null) {
      _internalController = TextEditingController();
    }

    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    if (_internalController != null) {
      _internalController!.removeListener(_handleTextChange);
      _internalController!.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        _hasError = widget.validator?.call(_controller.text) != null;
        _userInteracted = true;
      });
    }
  }

  void _handleTextChange() {
    if (mounted && _userInteracted) {
      setState(() {
        _hasError = widget.validator?.call(_controller.text) != null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label estático
        Text(
          widget.label ?? '',
          style: const TextStyle(
            /* color: _hasError 
                ? Colors.red
                : AppColors.primaryColor
                   , */
            fontSize: 16,
            fontWeight: FontWeight.normal,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 8), // Espacio entre el label y el input
        // Campo de texto
        TextFormField(
          cursorColor: AppColors.primaryColor,
          obscureText: widget.obscureText,
          validator: widget.validator,
          keyboardType: widget.textInputType,
          controller: _controller,
          onSaved: widget.onSave,
          focusNode: _focusNode,
       /*    autovalidateMode: AutovalidateMode.onUserInteraction, */
          decoration: InputDecoration(
           
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFFA4BAD9), width: 2),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color.fromARGB(255, 189, 189, 189), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 2,
                color: AppColors.primaryColor,
              ),
            ),
            fillColor: Color.fromARGB(255, 247, 247, 247),
            filled: true,
            contentPadding:
                const EdgeInsets.only(left: 15, bottom: 15, top: 15),
          ),
        ),
      ],
    );
  }
}
