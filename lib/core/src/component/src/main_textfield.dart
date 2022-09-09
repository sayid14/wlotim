import 'package:flutter/material.dart';

class MainTextField extends StatelessWidget {
  const MainTextField(
      {Key? key, this.hint, this.label, this.prefix, this.controller})
      : super(key: key);
  final String? hint;
  final String? label;
  final Widget? prefix;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          label: label == null ? null : Text(label!),
          prefixIcon: prefix),
    );
  }
}
