import 'package:flutter/material.dart';

class FormFieldLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const FormFieldLabel({
    super.key,
    required this.text,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      isRequired ? '$text*' : text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }
}