import 'dart:async';

import 'package:asapclient/home.dart';
import 'package:asapclient/models/restaurant_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' show sin, cos, sqrt, atan2, pi;
import 'package:geolocator/geolocator.dart';

class DeliveryScreen extends StatefulWidget {
  final Map<Food, int> selectedFoods;
  final Location location;

  const DeliveryScreen(
      {super.key, required this.selectedFoods, required this.location});

  @override
  // ignore: library_private_types_in_public_api
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController spicesController = TextEditingController();
  double? destinationLatitude;
  double? destinationLongitude;
  Position? _currentPosition;
  double _distance = 0;
  double delivery = 0;
  String status1 = 'Notifying courier';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _calculateDistance();
    _calculatefee();
    _calculateTotalAmount();
  }

  bool isLoading = false;
  String status = "Notifying courier";
  String courier = "Pending..";

  DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    destinationLatitude = widget.location.latitude;
    destinationLongitude = widget.location.longitude;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 27, 153),
        title: const Text('Delivery Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            SizedBox(height: h * 0.01),
            TextFormField(
              controller: streetNameController,
              decoration: const InputDecoration(
                labelText: 'Your location',
              ),
            ),
            SizedBox(height: h * 0.01),
            TextFormField(
              controller: spicesController,
              decoration: const InputDecoration(
                labelText: 'Additional Spices Information',
              ),
            ),
            SizedBox(height: h * 0.05),
            Text(
              'Distance : ${(_distance * 0.001).toStringAsFixed(2)} km',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: h * 0.01),
            Text(
              'Food Cost: Tshs ${_calculateTotalAmount().toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: h * 0.01),
            Text(
              'Delivery fee: Tshs ${_calculatefee().toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: h * 0.01),
            Text(
              'TOTAL: Tshs  ${totalcost().toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: h * 0.01),
            ElevatedButton(
              onPressed: (_distance != 0)
                  ? () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _startLoading();
                      if (widget.selectedFoods.isNotEmpty) {
                        if (phoneNumberController.text.isNotEmpty &&
                            streetNameController.text.isNotEmpty &&
                            _distance != 0) {
                          await _submitOrder();
                          const CircularProgressIndicator();
                          Fluttertoast.showToast(
                              msg: "Your order has been received");
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const Home())));

                          widget.selectedFoods.clear();
                        } else {
                          Fluttertoast.showToast(
                              msg: "Required phone number and location ");
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "You have not selected any food ");
                      }
                    }
                  : gettingDistance(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 5, 27, 153),
                  padding: EdgeInsets.symmetric(horizontal: w * 0.35)),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('SUBMIT'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitOrder() async {
    final firebaseuser = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;

    await firestore
        .collection('orders')
        .doc(firebaseuser!.uid)
        .collection('myorders')
        .add({
      'status': status1,
      'instruction': spicesController.text,
      'Total': totalcost(),
      'phone': phoneNumberController.text,
      'location': streetNameController.text,
      "Couriers phone": courier,
      "createdAt": FieldValue.serverTimestamp(),
      'selectedFoods': widget.selectedFoods.entries
          //'createdAt':FieldValue.serverTimestamp()
          .map((entry) => {'foodName': entry.key.name, 'quantity': entry.value})
          .toList(),
    });

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      _calculateDistance();
    } catch (e) {
      print(e);
    }
  }

  double _haversineDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const int radiusOfEarth = 6371;
    double dLat = (lat2 - lat1) * (pi / 180);
    double dLon = (lon2 - lon1) * (pi / 180);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radiusOfEarth * c;
  }

  void _calculateDistance() {
    if (_currentPosition == null) return;

    double currentLatitude = _currentPosition!.latitude;
    double currentLongitude = _currentPosition!.longitude;
    double destinationLat = destinationLatitude!;
    double destinationLon = destinationLongitude!;

    _distance = _haversineDistance(
      currentLatitude,
      currentLongitude,
      destinationLat,
      destinationLon,
    );
  }

  double _calculateTotalAmount() {
    double totalAmount = 0;
    widget.selectedFoods.forEach((food, quantity) {
      totalAmount += food.price * quantity;
    });
    return totalAmount;
  }

  double _calculatefee() {
    double d = _distance * 0.001;

    if (d <= 1) {
      return 2000;
    }
    delivery = 2000 + ((d-1) * 1000);

    int rem2 = delivery.toInt();
    int rem = rem2 % 1000;

    if (rem < 250) {
      return (rem2 ~/ 1000) * 1000;
    } else if (rem < 750) {
      return (rem2 ~/ 1000) * 1000 + 500;
    } else {
      return (rem2 ~/ 1000 + 1) * 1000;
    }
  }

  double totalcost() {
    return _calculatefee() + _calculateTotalAmount();
  }

  gettingDistance() {
    const Text(
      'Getting distance',
      style: TextStyle(color: Colors.red),
    );
  }

  void _cancelDelayedOperation() {
    if (_isLoadingDelayedOperation != null &&
        _isLoadingDelayedOperation!.isActive) {
      _isLoadingDelayedOperation!.cancel();
    }
  }

  Timer? _isLoadingDelayedOperation;

  void _startLoading() {
    setState(() {
      isLoading = true;
    });

    _isLoadingDelayedOperation = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    streetNameController.dispose();
    spicesController.dispose();
    _cancelDelayedOperation();
    super.dispose();
  }
}
