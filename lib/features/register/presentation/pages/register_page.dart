import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wlotim/core/core.dart';
import 'package:wlotim/features/login/presentation/pages/login_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLooadingAuth = false;
  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  final rePassCon = TextEditingController();
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
                "Register",
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
                height: 20,
              ),
              MainTextField(
                controller: rePassCon,
                label: "Ulangi Password",
                hint: "Masukan Ulang password",
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
                        if (passCon.text.isEmpty || rePassCon.text.isEmpty) {
                          return;
                        }
                        if (passCon.text != rePassCon.text) {
                          DefaultDialog(
                            title: "Maaf",
                            content: "password tidak match",
                          ).showError(context);
                          return;
                        }
                        state.call(
                          () {
                            isLooadingAuth = true;
                          },
                        );
                        try {
                          final res =
                              await _auth.createUserWithEmailAndPassword(
                                  email: emailCon.text, password: passCon.text);
                          await FirebaseFirestore.instance
                              .collection(FirestoreConst.profile)
                              .doc(res.user?.uid)
                              .set({
                            "type": 1,
                          });
                          DefaultDialog(
                            title: "Sukses",
                            content: "Berhasil daftar akun",
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
                            title: "error",
                            content: e.toString(),
                          ).showError(context);
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
                        "Daftar",
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
                  const Text("Sudah punya akun ? "),
                  InkWell(
                    onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                        (route) => true),
                    child: const Text(
                      "Masuk",
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
