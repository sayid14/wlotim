import 'package:flutter/material.dart';
import 'package:wlotim/core/core.dart';
import 'package:wlotim/features/beranda/presentation/pages/beranda_page.dart';
import 'package:wlotim/features/login/presentation/pages/login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
              const MainTextField(
                label: "Email",
                hint: "Masukan email",
                prefix: Icon(Icons.email),
              ),
              const SizedBox(
                height: 20,
              ),
              const MainTextField(
                label: "Password",
                hint: "Masukan password",
                prefix: Icon(Icons.key),
              ),
              const SizedBox(
                height: 20,
              ),
              const MainTextField(
                label: "Ulangi Password",
                hint: "Masukan Ulang password",
                prefix: Icon(Icons.key),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BerandaPage(),
                          ),
                          (route) => true);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[400])),
                    child: const Text(
                      "Daftar",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    )),
              ),
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
                          builder: (context) => const LoginPage(),
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
