import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveCheckboxWithLabelAndError extends StatelessWidget {
  final String formControlName;
  final String label;
  final Map<String, String Function(Object)> validationMessages;
  final VoidCallback? onTap;

  const ReactiveCheckboxWithLabelAndError({
    Key? key,
    required this.formControlName,
    required this.label,
    required this.validationMessages,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ReactiveCheckbox(
              formControlName: formControlName,
              showErrors: (control) => control.invalid && control.touched,
            ),
            GestureDetector(
              onTap: onTap,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        ReactiveValueListenableBuilder<bool>(
          formControlName: formControlName,
          builder: (context, control, child) {
            return control.invalid && control.touched
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      validationMessages['requiredTrue']!(control.errors.entries.first.value),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}