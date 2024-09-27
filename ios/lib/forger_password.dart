import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modul8app_1/widget.dart';

class ForgerPassword extends StatefulWidget {
  const ForgerPassword({super.key});

  @override
  State<ForgerPassword> createState() => _ForgerPasswordState();
}

class _ForgerPasswordState extends State<ForgerPassword> {
  static bool passwordRecovery = true;
  String email = "";
  String code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 90,
                child: Row(
                  children: [
                    Image.asset(
                      "images/Group.png",
                      height: 30,
                    ),
                    const Text(
                      " installpay",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Text(
                passwordRecovery ? "Password Recovery" : "Change Password",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                passwordRecovery
                    ? "Please put your information below to log in to your account"
                    : "Create a new, strong password that you don't use before",
                style: TextStyle(
                    color: Colors.white.withOpacity(.7), fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              MyTextFild(
                  press: (email) {
                    email = email;
                    Navigator.pop(context);
                  },
                  text: "Email",
                  obscureText: false,
                  textInputType: TextInputType.emailAddress),
              GestureDetector(
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.verifyPasswordResetCode(code);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(color: const Color(0xffd2fe55)),
                  child: Text(
                    passwordRecovery ? "Login" : "Create account",
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
