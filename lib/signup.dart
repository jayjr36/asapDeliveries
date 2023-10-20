// ignore_for_file: use_build_context_synchronously

import 'package:asapclient/login.dart';
import 'package:asapclient/privacypolicy.dart';
import 'package:asapclient/terms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailctrl = TextEditingController();
  TextEditingController namectrl = TextEditingController();
  TextEditingController phonectrl = TextEditingController();
  TextEditingController passwordctrl = TextEditingController();
  TextEditingController cpasswordctrl = TextEditingController();
  String? errorMessage;
  bool loading = false;

  bool _termsAccepted = false;

  void _toggleTermsAccepted(bool? value) {
    setState(() {
      _termsAccepted = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (() {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(h * 0.1)),
                gradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 2, 3, 20),
                  Color.fromARGB(255, 5, 27, 153)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          title: Column(children: [
            Center(
              child: Image.asset(
                'assets/asp1.png',
                height: h * 0.2,
                width: w * 0.4,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: w * 0.6),
              child: const Text("REGISTER"),
            )
          ]),
          toolbarHeight: h * 0.3,
          //shape: _Customshapedborder(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: w * 0.1, vertical: h * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_rounded),
                        focusColor: Colors.blue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(h * 0.02),
                        ),
                        hintText: 'Name',
                        labelText: 'Name'),
                    controller: namectrl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_rounded),
                        focusColor: Colors.blue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(h * 0.02),
                        ),
                        hintText: 'Email',
                        labelText: 'Email'),
                    controller: emailctrl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_rounded),
                        focusColor: Colors.blue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(h * 0.02),
                        ),
                        hintText: 'Phone',
                        labelText: 'Phone'),
                    controller: phonectrl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password_rounded),
                      hintText: 'Password',
                      labelText: 'Password',
                      focusColor: Colors.blue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(h * 0.02),
                      ),
                    ),
                    controller: passwordctrl,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password_rounded),
                      hintText: 'Confirm Password',
                      labelText: 'Confirm Password',
                      focusColor: Colors.blue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(h * 0.02),
                      ),
                    ),
                    controller: cpasswordctrl,
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Checkbox(
                        value: _termsAccepted, onChanged: _toggleTermsAccepted),
                    const Text('I agree to the '),
                    InkWell(
                      onTap: _showTermsAndConditions,
                      child: const Text(
                        'Terms and conditions ',
                        style: TextStyle(
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    const Text('and the '),
                    InkWell(
                      onTap: _showPrivacyPolicy,
                      child: const Text(
                        'Privacy policy',
                        style: TextStyle(
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: h * 0.02),
                  child: ElevatedButton(
                    onPressed: _termsAccepted
                        ? () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              loading = true;
                            });
                            if (passwordctrl.text == cpasswordctrl.text) {
                              //signUp(emailctrl.text, passwordctrl.text,
                              //  phonectrl.text, namectrl.text);
                              _registerUser();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "The input password does not match");
                            }
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                loading = false;
                              });
                            });
                          }
                        : () {
                            warning();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Color.fromARGB(255, 2, 3, 20),
                            Color.fromARGB(255, 5, 27, 153)
                          ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight)),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: w * 0.2),
                        constraints: BoxConstraints(
                            minHeight: h * 0.05, minWidth: w * 0.2),
                        child: const Text(
                          "REGISTER",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: h * 0.02),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                                (route) => false);
                          },
                          child: const Text("SIGN IN")),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTermsAndConditions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Termsc(),
      ),
    );
  }

  void _showPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Privacy(),
      ),
    );
  }

  warning() {
    Fluttertoast.showToast(
      msg: "Please accept the terms and conditions or privacy policy",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void _registerUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailctrl.text,
        password: passwordctrl.text,
      );

      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': namectrl.text,
          'phone': phonectrl.text,
          'email': emailctrl.text,
          'password': passwordctrl.text
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
