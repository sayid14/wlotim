import 'package:flutter/material.dart';

class MainTextField extends StatelessWidget {
  MainTextField(
      {Key? key,
      this.hint,
      this.label,
      this.prefix,
      this.controller,
      this.suffix,
      this.readOnly = false,
      this.maxLines = 1})
      : super(key: key);
  final String? hint;
  final String? label;
  final Widget? prefix;
  final Widget? suffix;
  final TextEditingController? controller;
  bool readOnly;
  int? maxLines;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType:
          (maxLines ?? 1) > 1 ? TextInputType.multiline : TextInputType.text,
      decoration: InputDecoration(
          hintText: hint,
          label: label == null ? null : Text(label!),
          prefixIcon: prefix,
          suffixIcon: suffix),
    );
  }
}
