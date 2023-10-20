// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:asapclient/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  Profile({super.key});

  String? username1;
  String? phone1;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Drawer(
        child: FutureBuilder(
            future: getuserdata(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final useremail = (FirebaseAuth.instance.currentUser!).email;
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      decoration: const BoxDecoration(),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: h*0.03),
                            child: Icon(
                              Icons.person,
                              size: h * 0.18,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: w * 0.03, top: h*0.1),
                            child:  Text(
                              'USER \nPROFILE',
                              style: TextStyle(color: Colors.blue,
                              fontSize: h*0.03,
                              fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    ListTile(
                      onTap: (() => Navigator.of(context).pop()),
                      leading: const Icon(Icons.person),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Name',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '$username1',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    ListTile(
                      leading: const Icon(Icons.email_rounded),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '$useremail',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    ListTile(
                      leading: const Icon(Icons.contact_phone_rounded),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Phone',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '$phone1',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.4),
                   
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 5, 27, 153)
                      ),
                      child: ListTile(
                        
                        leading: TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                      
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            },
                            child: const Text(
                              "SIGNOUT",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            )),
                            trailing: IconButton(onPressed: (){
                              FirebaseAuth.instance.signOut();
                      
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            
                            }, icon: Icon(Icons.settings_power,
                            color: Colors.red,
                            size: h*0.05,
                            )),
                      ),
                    )
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Future getCurrentUser() async {
    return (FirebaseAuth.instance.currentUser!);
  }

  final uid = (FirebaseAuth.instance.currentUser!).uid;

  final firebaseuser = FirebaseAuth.instance.currentUser;

  getuserdata() async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection("users");
    DocumentSnapshot userdata = await reference.doc(firebaseuser!.uid).get();
    username1 = userdata.get("username");
    phone1 = userdata.get("phone");
    return [username1, phone1];
  }
}

