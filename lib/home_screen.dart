// ignore_for_file: depend_on_referenced_packages

import 'package:asapclient/profile.dart';
import 'package:asapclient/restaurants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Homepg extends StatefulWidget {
  const Homepg({super.key});

  @override
  State<Homepg> createState() => _HomepgState();
}

class _HomepgState extends State<Homepg> {
  String? username1;
  get user => FirebaseAuth.instance.currentUser;

  // ignore: recursive_getters
  get key => key;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        drawer:  Profile(), 
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 5, 27, 153),
          automaticallyImplyLeading: true,
          
        ),
        body: SafeArea(
            child: ListView(
          children: [
            FutureBuilder(
                future: getuserdata(),
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.only(left: w * 0.04, top: h * 0.02),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          'Hi  $username1',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Lobster',
                          ),
                        ),
                       
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: h * 0.8,
              child: Center(
                  child: SizedBox(
                height: h * 0.75,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: h * 0.015,
                    ),
                    SizedBox(
                      height: h*0.25,
                      child: ListView(
                        children: [
                          CarouselSlider(
                            items: [
                              Container(
                                margin: EdgeInsets.all(h * 0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(h * 0.02),
                                    image: DecorationImage(
                                        image:
                                            const AssetImage("assets/one.jpeg"),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.4),
                                            BlendMode.darken))),
                                child: Stack(children:  [
                                  Positioned(
                                    bottom: h*0.03,
                                    left: h*0.09,
                                    child: const Text(
                                      "Let's get you a \n     delicious meal",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ]),
                              ),
                              Container(
                                margin: EdgeInsets.all(h*0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(h*0.02),
                                    image: DecorationImage(
                                        image:
                                            const AssetImage("assets/two.jpeg"),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.4),
                                            BlendMode.darken))),
                                child: Stack(children:  [
                                  Positioned(
                                    bottom: h*0.03,
                                    left: h*0.03,
                                    child: const Text(
                                      "Instant food delivery right \n            where you are",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ]),
                              ),
                              Container(
                                margin: EdgeInsets.all(h*0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(h*0.02),
                                    image: DecorationImage(
                                        image: const AssetImage(
                                            "assets/three.jpeg"),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.4),
                                            BlendMode.darken))),
                                child: Stack(children:  [
                                  Positioned(
                                    top: h*0.03,
                                    left: h*0.09,
                                    child: const Text(
                                      "WELCOME",
                                      style: TextStyle(
                                          letterSpacing: 5,
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Positioned(
                                    top: h*0.06,
                                    left: h*0.15,
                                    child: const Text(
                                      "TO",
                                      style: TextStyle(
                                          letterSpacing: 0.2,
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Positioned(
                                    top: h*0.09,
                                    left: h*0.13,
                                    child: const Text(
                                      "ASAP",
                                      style: TextStyle(
                                          letterSpacing: 0.2,
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Positioned(
                                    top: h*0.12,
                                    left: h*0.11,
                                    child: const Text(
                                      "DELIVERY",
                                      style: TextStyle(
                                          letterSpacing: 0.2,
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ]),
                              ),
                            ],
                            options: CarouselOptions(
                                height: h*0.23,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                viewportFraction: 0.8),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: h * 0.03),
                      child: const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Most popular foods',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      shadowColor: Colors.blue,
                      child: SizedBox(
                        height: h * 0.12,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Card(
                                child: Container(
                                  height: h * 0.1,
                                  width: w * 0.25,
                                  margin: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      image: DecorationImage(
                                          image: const NetworkImage(
                                            "https://images.unsplash.com/photo-1571407970349-bc81e7e96d47?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=725&q=80",
                                          ),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.4),
                                              BlendMode.darken))),
                                  child: const Stack(children: [
                                    Positioned(
                                      bottom: 5,
                                      left: 22,
                                      child: Text(
                                        "PIZZA",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                              Card(
                                child: Container(
                                  height: h * 0.1,
                                  width: w * 0.25,
                                  margin: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      image: DecorationImage(
                                          image: const NetworkImage(
                                            "https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8c3RlYWt8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
                                          ),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.4),
                                              BlendMode.darken))),
                                  child: const Stack(children: [
                                    Positioned(
                                      bottom: 5,
                                      left: 18,
                                      child: Text(
                                        "STEAK",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                              Card(
                                child: Container(
                                  height: h * 0.1,
                                  width: w * 0.25,
                                  margin: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      image: DecorationImage(
                                          image: const NetworkImage(
                                            "https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fGZyaWVkJTIwcmljZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
                                          ),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.4),
                                              BlendMode.darken))),
                                  child: const Stack(children: [
                                    Positioned(
                                      bottom: 5,
                                      left: 12,
                                      child: Text(
                                        "BIRYANI",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                              Card(
                                child: Container(
                                  height: h * 0.1,
                                  width: w * 0.25,
                                  margin: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      image: DecorationImage(
                                          image: const NetworkImage(
                                            "https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8ZnJpZWQlMjBjaGlja2VufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
                                          ),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.4),
                                              BlendMode.darken))),
                                  child: const Stack(children: [
                                    Positioned(
                                      bottom: 5,
                                      left: 11,
                                      child: Text(
                                        "CHICKEN",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                              Card(
                                child: Container(
                                  height: h * 0.1,
                                  width: w * 0.25,
                                  margin: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      image: DecorationImage(
                                          image: const NetworkImage(
                                            "https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8ZnJpZXN8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
                                          ),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.4),
                                              BlendMode.darken))),
                                  child: const Stack(children: [
                                    Positioned(
                                      bottom: 5,
                                      left: 22,
                                      child: Text(
                                        "FRIES",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Restaurants()));
                                  },
                                  child: const Text(
                                    ' See \n all ',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.red),
                                  ))
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.015,
                    ),
                    Card(
                      elevation: h*0.01,
                      child: Container(
                        height: h * 0.15,
                        width: w * 0.9,
                        margin: EdgeInsets.all(h*0.01),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(h*0.02),
                            image: DecorationImage(
                                image: const AssetImage('assets/delv.jpeg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.darken))),
                        child: const Stack(children: [
                          Positioned(
                            bottom: 25,
                            left: 55,
                            child: Text(
                              "QUICK DELIVERY",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 60,
                            child: Text(
                              "FOR 1000Tshs ONLY",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.022,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Restaurants()));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue.shade800),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: w * 0.25, vertical: h * 0.01)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(h*0.02),
                                  side: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 21, 65, 22))))),
                      child: const Text(
                        "MAKE AN ORDER",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ],
        )));
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
    
    return username1;
  }
}
