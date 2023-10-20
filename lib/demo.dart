import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Restaurant App',
      home: JsonReader(),
    );
  }
}

class Restaurant {
  final int id;
  final String name;
  final String image;
  final Location location;
  final List<Food> foods;

  Restaurant(this.id, this.name, this.image, this.location, this.foods);

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      json['id'],
      json['name'],
      json['image'],
      Location.fromJson(json['location']),
      (json['foods'] as List)
          .map((foodJson) => Food.fromJson(foodJson))
          .toList(),
    );
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      json['latitude'].toDouble(),
      json['longitude'].toDouble(),
    );
  }
}

class Food {
  final String name;
  final double price;
  final String foodImage;

  Food(this.name, this.price, this.foodImage);

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(json['name'], json['price'].toDouble(), json['foodImage']);
  }
}

class JsonReader extends StatefulWidget {
  const JsonReader({super.key});

  @override
  _JsonReaderState createState() => _JsonReaderState();
}

class _JsonReaderState extends State<JsonReader> {
  List<Restaurant> restaurants = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        'https://github.com/jayjr36/restAPI_FLUTTER/raw/main/restaurant.json'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        restaurants = (jsonData as List)
            .map((restaurantJson) => Restaurant.fromJson(restaurantJson))
            .toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return ListTile(
            title: Text(restaurant.name),
            subtitle: Text('Latitude: ${restaurant.location.latitude}, Longitude: ${restaurant.location.longitude}'),
            leading: Image.network(
              restaurant.image,
              width: 50,
              height: 50,
            ),
            // Add more details as needed
          );
        },
      ),
    );
  }
}
