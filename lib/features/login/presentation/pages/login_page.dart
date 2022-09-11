import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wlotim/core/core.dart';
import 'package:wlotim/features/beranda/presentation/pages/beranda_page.dart';
import 'package:wlotim/features/beranda_admin/presentation/pages/beranda_admin_page.dart';

import '../../../register/presentation/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLooadingAuth = false;
  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                width: MediaQuery.of(context).size.width * .5,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "LOGIN",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.width * .08),
              ),
              const SizedBox(
                height: 25,
              ),
              MainTextField(
                controller: emailCon,
                label: "Email",
                hint: "Masukan email",
                prefix: const Icon(Icons.email),
              ),
              const SizedBox(
                height: 20,
              ),
              MainTextField(
                controller: passCon,
                label: "Password",
                hint: "Masukan password",
                prefix: const Icon(Icons.key),
              ),
              const SizedBox(
                height: 30,
              ),
              StatefulBuilder(builder: (context, state) {
                if (isLooadingAuth) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      onPressed: () async {
                        state.call(
                          () {
                            isLooadingAuth = true;
                          },
                        );
                        try {
                          final res = await _auth.signInWithEmailAndPassword(
                              email: emailCon.text, password: passCon.text);
                          final data = await FirebaseFirestore.instance
                              .collection(FirestoreConst.profile)
                              .doc(res.user?.uid)
                              .get();
                          final pref = await SharedPreferences.getInstance();
                          pref.setInt(SharedPrefrencesConst.userType,
                              data.data()?["type"] ?? 0);
                          DefaultDialog(
                            title: "Sukses",
                            content: "Login Berhasil",
                            autoCloseDuration: const Duration(seconds: 3),
                          ).showSuccess(context).then((value) async {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      data.data()?["type"] == 1
                                          ? const BerandaPage()
                                          : const BerandaAdminPage(),
                                ),
                                (route) => true);
                          });
                          log(res.user?.uid ?? "-");
                        } catch (e) {
                          DefaultDialog(
                            title: "Maaf",
                            content: "Email atau password salah",
                          ).showError(context);
                          log(e.toString());
                        }
                        state.call(
                          () {
                            isLooadingAuth = false;
                          },
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[400])),
                      child: const Text(
                        "Masuk",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      )),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun ? "),
                  InkWell(
                    onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                        (route) => true),
                    child: const Text(
                      "Daftar",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
