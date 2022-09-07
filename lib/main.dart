import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:wlotim/features/splash/presentation/pages/presentation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SpalashPage());
  }
}
