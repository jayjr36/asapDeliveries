// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PreviousOrders extends StatefulWidget {
  const PreviousOrders({super.key});

  @override
  State<PreviousOrders> createState() => _PreviousOrdersState();
}

class _PreviousOrdersState extends State<PreviousOrders>
    with TickerProviderStateMixin {
  late TabController tabctrl;

  @override
  void initState() {
    super.initState();
    tabctrl = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: h * 0.07,
        backgroundColor: const Color.fromARGB(255, 5, 27, 153),
        bottom: TabBar(controller: tabctrl, tabs: const [
          Tab(
            icon: Icon(Icons.cloud_circle_outlined),
            text: "Pending",
          ),
          Tab(
            icon: Icon(Icons.beach_access_outlined),
            text: "In progress",
          )
        ]),
        title: SizedBox(
            width: w,
            child: const Center(
              child: Text(
                'MY ORDERS',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            )),
      ),
      body: TabBarView(
          controller: tabctrl,
          children: const [Pendingorder(), Progressingorders()]),
    );
  }
}

class Progressingorders extends StatefulWidget {
  const Progressingorders({super.key});

  @override
  State<Progressingorders> createState() => _ProgressingordersState();
}

class _ProgressingordersState extends State<Progressingorders> {
  String status = "In progress";
  String status1 = "Cancelled";

  List<dynamic> allData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        // .where("status", isEqualTo:status2)
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
                        'ORDER IN PROGRESS',
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
                  SizedBox(
                    height: h * 0.01,
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
                  
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Wrap(
                    children: [
                      const Text(
                        "Courier's phone: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        " ${order['Couriers phone'].toString()}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
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
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        onPressed: () {
                          order.reference.update({"status": status1});
                        },
                        style: ButtonStyle(
                            // backgroundColor:
                            // MaterialStateProperty.all(Colors.red.shade500),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: w * 0.01, vertical: h * 0.01))),
                        child: const Text(
                          "CANCEL",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.black),
                        )),
                  )
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

class Pendingorder extends StatefulWidget {
  const Pendingorder({super.key});

  @override
  State<Pendingorder> createState() => _PendingorderState();
}

class _PendingorderState extends State<Pendingorder> {
  final firebaseuser = FirebaseAuth.instance.currentUser!;
  String status1 = "Cancelled";
  String status = "Notifying courier";

  List<dynamic> allData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      elevation: 10,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue.shade800, width: 2),
          borderRadius: BorderRadius.circular(h * 0.02)),
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
                        'ORDER RECEIVED',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    height: h * 0.001,
                  ),
                  Wrap(
                    children: [
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
                        width: h * 0.03,
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
                  Wrap(
                    children: [
                      const Text(
                        "Instruction: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        order['instruction'].toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Wrap(
                    children: [
                      const Text(
                        "Total: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        order['Total'].toStringAsFixed(0),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Wrap(
                    children: [
                      const Text(
                        "Courier's phone: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        " ${order['Couriers phone'].toString()}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
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
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        onPressed: () {
                          order.reference.update({"status": status1});
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: w * 0.05, vertical: h * 0.01))),
                        child: const Text(
                          "CANCEL",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.red),
                        )),
                  )
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
