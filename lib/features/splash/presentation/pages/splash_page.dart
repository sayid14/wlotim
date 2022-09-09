import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wlotim/features/beranda/presentation/pages/beranda_page.dart';

import '../../../login/presentation/pages/login_page.dart';

class SpalashPage extends StatefulWidget {
  const SpalashPage({super.key});

  @override
  State<SpalashPage> createState() => _SpalashPageState();
}

class _SpalashPageState extends State<SpalashPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () async {
        if (_auth.currentUser != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BerandaPage(),
              ),
              (route) => true);
          return;
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
            (route) => true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: Image.asset("assets/logo.png"),
        ),
      ),
    );
  }
}
