import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:asapclient/models/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:asapclient/menu.dart';
class Restaurants extends StatefulWidget {
  const Restaurants({super.key});

  @override
  State<Restaurants> createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 27, 153),
        title: const Text('Restaurant List'),
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: fetchRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final restaurant = snapshot.data![index];
                return ListTile(
                  leading: Image.network(restaurant.image,
                  width: w*0.1,
                  height: h*0.05,),
                  title: Text(restaurant.name),
                  subtitle: Text('Foods: ${restaurant.foods.length}'),
                onTap: () {
                  _navigateToMenuScreen(restaurant);
                },
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      
    
    
    );
  }

    Future<List<Restaurant>> fetchRestaurants() async {
    final response = await http.get(Uri.parse(
        'https://github.com/jayjr36/restAPI_FLUTTER/raw/main/restaurant.json'));

    if (response.statusCode == 200) {
      final List<dynamic> rawData = json.decode(response.body);
      final List<Restaurant> restaurants =
          rawData.map((data) => Restaurant.fromJson(data)).toList();
      return restaurants;
    } else {
      throw Exception('Failed to load restaurant data');
    }
  }

  void _navigateToMenuScreen(Restaurant restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuScreen(restaurant: restaurant),
      ),
    );
  }


}

