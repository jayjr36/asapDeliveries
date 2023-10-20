import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: h * 0.1,
          backgroundColor: const Color.fromARGB(255, 5, 27, 153),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'INFO',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
             Padding(
              padding: EdgeInsets.only(left: h*0.02, right: h*0.02, top: h*0.02),
              child: const Text(
                  'ASAP DELIVERY is dedicated to offer food delivery services to university students at an affordable price.\nCurrently we offer delivery services to universities located around Dar es salaam.', 
                  style: TextStyle(fontSize: 16,
                  ),),
            ),
           Padding(
              padding: EdgeInsets.only(left: h*0.02, right: h*0.02, top: h*0.02),
              child: const Text(
                'For any enquries contact us through',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: h*0.02, right: h*0.02, top: h*0.01),
              child: const Wrap(
                children: [
                  Text('EMAIL: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),),
                  Text(
                    'asapteaam@gmail.com',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
             Padding(
              padding: EdgeInsets.only(left: h*0.02, right: h*0.02, top: h*0.01),
              child: const Wrap(
                children: [
                  Text('Phone:  ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),),
                  Text(
                    '0626879287',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
