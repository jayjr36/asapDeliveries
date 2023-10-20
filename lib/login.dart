import 'package:asapclient/home.dart';
import 'package:asapclient/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailctrl = TextEditingController();
  TextEditingController passwordctrl = TextEditingController();
  String? errorMessage;
  bool loading = false;

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
              child: const Text("LOGIN"),
            )
          ]),
          toolbarHeight: h * 0.3,
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
                        hintText: 'email',
                        labelText: 'email'),
                    controller: emailctrl,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter Your Email");
                      }
                      // reg expression for email validation
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return ("Please Enter a valid email");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      emailctrl.text = value!;
                    },
                    textInputAction: TextInputAction.next,
                    autofocus: false,
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
                      hintText: 'password',
                      labelText: 'password',
                      focusColor: Colors.blue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(h * 0.02),
                      ),
                    ),
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return ("Password is required for login");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Enter Valid Password(Min. 6 Character)");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      passwordctrl.text = value!;
                    },
                    textInputAction: TextInputAction.next,
                    controller: passwordctrl,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: w * 0.4),
                  child: TextButton(
                      onPressed: () {
                        //TODO: GO TO PASSWORD RESET
                      },
                      child: const Text('Forgot password?')),
                ),
                Padding(
                  padding: EdgeInsets.only(top: h * 0.1),
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        loading = true;
                      });
                      if (emailctrl.text.isNotEmpty &&
                          passwordctrl.text.isNotEmpty) {
                        signIn(emailctrl.text, passwordctrl.text);
                        const CircularProgressIndicator();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Email and password can not be empty");
                      }
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          loading = false;
                        });
                      });
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
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "LOGIN",
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
                  padding: EdgeInsets.only(top: h * 0.1),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Signup()), (route) => false);
                          },
                          child: const Text("SIGNUP")),
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

  void signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Home())),
              });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";

          break;
        case "wrong-password":
          errorMessage = "Incorrect password.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "No internet connection";
      }
      Fluttertoast.showToast(msg: errorMessage!);
    }
  }
}
