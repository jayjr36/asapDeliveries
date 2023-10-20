class Restaurant {
  final int id;
  final String name;
  final String image;
  final Location location;
  final List<Food> foods;

  Restaurant(this.id, this.name, this.foods, this.image, this.location);

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      json['id'],
      json['name'],
      (json['foods'] as List)
          .map((foodJson) => Food.fromJson(foodJson))
          .toList(),
      json['image'],
      Location.fromJson(json['location']), // Parse location as a map
    );
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      json['latitude'].toDouble(), // Parse latitude as double
      json['longitude'].toDouble(), // Parse longitude as double
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

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price, 'foodImage': foodImage};
  }
}
