import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wlotim/core/core.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
              Text(
                "LOGIN",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.width * .1),
              ),
              SizedBox(
                height: 25,
              ),
              MainTextField(),
              SizedBox(
                height: 20,
              ),
              MainTextField(),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[400])),
                    child: Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    )),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
