import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wlotim/core/core.dart';
import 'package:wlotim/features/login/presentation/pages/login_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StatefulBuilder(builder: (context, state) {
          return ElevatedButton(
              onPressed: () async {
                state.call(
                  () {
                    isLoading = true;
                  },
                );
                try {
                  _auth.signOut();
                  DefaultDialog(
                    title: "Sukses",
                    content: "Anda berhasil logout",
                    autoCloseDuration: const Duration(seconds: 3),
                  )
                      .showSuccess(context)
                      .then((value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                          (route) => true));
                } catch (e) {
                  DefaultDialog(
                    title: "maaf",
                    content: "Terjadi gangguan saat logout",
                  ).showError(context);
                  log(e.toString());
                }
                state.call(
                  () {
                    isLoading = false;
                  },
                );
              },
              child: const Text("Log out"));
        }),
      ),
    );
  }
}
