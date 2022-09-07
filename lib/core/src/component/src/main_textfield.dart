import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainTextField extends StatelessWidget {
  const MainTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration:
          InputDecoration(hintText: "Username", prefixIcon: Icon(Icons.person)),
    );
  }
}
