import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool expands;
  final double? height;
  final String? errorText;
  final Widget? suffixIcon;
  final bool enabled;
  final VoidCallback? onTap;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.expands = false,
    this.height,
    this.errorText,
    this.suffixIcon,
    this.enabled = true,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget textField = TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      expands: expands,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      textAlignVertical: expands ? TextAlignVertical.top : null,
      style: TextStyle(fontSize: expands ? 14.0 : null),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: expands ? 16.0 : 8,
          horizontal: 12,
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:  BorderSide(
            color: Colors.blue,
            width: readOnly ? 1 : 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: readOnly ? Colors.grey[50] : Colors.white,
        errorText: errorText,
        alignLabelWithHint: expands ? true : null,
      ),
    );

    if (height != null) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: textField,
      );
    }

    return textField;
  }
}