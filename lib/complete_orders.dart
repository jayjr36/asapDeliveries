// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompleteOrder extends StatefulWidget {
  const CompleteOrder({super.key});

  @override
  State<CompleteOrder> createState() => _CompleteOrderState();
}

class _CompleteOrderState extends State<CompleteOrder> {
  int ordcount = 0;
  String status = "Delivered";
  List<dynamic> allData = [];
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: null,
        toolbarHeight: h * 0.15,
        backgroundColor: const Color.fromARGB(255, 5, 27, 153),
        title: const Center(
            child: Text(
          'HISTORY',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        )),
      ),
      body: StreamBuilder(
          stream: getUsersOrderStreamSnapshot(context),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) =>
                    buildFoodcard(context, snapshot.data.docs[index]));
          }),
    );
  }

  Stream<QuerySnapshot> getUsersOrderStreamSnapshot(
      BuildContext context) async* {
    final firebaseuser = FirebaseAuth.instance.currentUser;

    yield* FirebaseFirestore.instance
        .collection("orders")
        .doc(firebaseuser!.uid)
        .collection('myorders')
        .orderBy('createdAt', descending: true)
        .where("status", isEqualTo: status)
        .snapshots();

    FirebaseFirestore.instance
        .collection('orders')
        .doc(firebaseuser.uid)
        .collection('myorders')
        .get()
        .then((value) {
      // ignore: avoid_function_literals_in_foreach_calls
      value.docs.forEach((element) {
        allData = element['selectedFoods'];
      });
      return allData;
    });
  }

  Widget buildFoodcard(BuildContext context, DocumentSnapshot order) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Timestamp mytime = order['createdAt'];
    DateTime mydate = mytime.toDate();

    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(mydate);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue.shade800, width: 2),
          borderRadius: BorderRadius.circular(10)),
      borderOnForeground: true,
      shadowColor: Colors.green,
      margin: EdgeInsets.all(h * 0.02),
      child: Padding(
        padding: EdgeInsets.all(h * 0.02),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: h * 0.02, bottom: h * 0.02),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.blue.shade800,
                    height: h * 0.035,
                    width: w,
                    child: const Center(
                      child: Text(
                        'DELIVERED',
                        style: TextStyle(fontSize: 22, color: Colors.green),
                      ),
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Wrap(
                    children: [
                      const Text(
                        'Location: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        order["location"].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Wrap(
                    children: [
                      const Text(
                        'Phone: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        order["phone"].toString(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Text(
                    _buildFoodList(order['selectedFoods']),
                    style: const TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Text(
                    order['quantity'].toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Text(
                    "Rider phone: ${order['Couriers phone'].toString()}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Wrap(children: [
                    const Text(
                      'Status: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      order['status'].toString(),
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _buildFoodList(List<dynamic> selectedFoods) {
    String foodList = '';

    for (var food in selectedFoods) {
      String foodName = food['foodName'];
      int quantity = food['quantity'];
      foodList += '$foodName: $quantity\n';
    }

    return foodList;
  }
}
