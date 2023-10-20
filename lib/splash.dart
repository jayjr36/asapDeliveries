import 'dart:async';

import 'package:asapclient/login.dart';
import 'package:flutter/material.dart';
import 'package:asapclient/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    user != null ? const Home() : const Login())));
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromARGB(255, 2, 3, 20),
                  Color.fromARGB(255, 5, 27, 153)
                
          ])),
      width: w,
      height: h,
      child: const Center(
        child: SizedBox(
          height: 200,
          width: 300,
          child: Image(
              image: AssetImage(
            'assets/asp4.png',
          )),
        ),
      ),
    );
  }
}
