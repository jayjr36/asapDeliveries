import 'package:asapclient/complete_orders.dart';
import 'package:asapclient/info.dart';
import 'package:asapclient/previous_orders.dart';
import 'package:flutter/material.dart';
import './home_screen.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static List<Widget> pages = <Widget>[
    const Homepg(),
    const PreviousOrders(),
    const CompleteOrder(),
    const InfoPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Colors.green.shade900;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor:const Color.fromARGB(255, 5, 27, 153),
            type: BottomNavigationBarType.fixed,

            ///fixedColor: Colors.blue,
            unselectedItemColor: Colors.white,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                
                icon: Icon(
                  Icons.backup_table_rounded,
                  color: Colors.white,
                ),
                label: 'HOME',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive_rounded,
                  color: Colors.white,
                ),
                label: 'MY ORDERS',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive_rounded,
                  color: Colors.white,
                ),
                label: 'COMPLETE',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                ),
                label: 'INFO',
              )
            ]));
  }
}
