import 'package:asapclient/delivery.dart';
import 'package:asapclient/models/restaurant_model.dart';
import 'package:flutter/material.dart';


class MenuScreen extends StatefulWidget {
  final Restaurant restaurant;
  
  const MenuScreen({super.key, required this.restaurant,});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Map<Food, int> selectedFoods = {};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const  Color.fromARGB(255, 5, 27, 153),
        title: Text(widget.restaurant.name),
      ),
      body: ListView.builder(
        itemCount: widget.restaurant.foods.length,
        itemBuilder: (context, index) {
          final food = widget.restaurant.foods[index];
          return ListTile(
            leading: Image.network(food.foodImage),
            title: Text(food.name),
            subtitle: Text('\$${food.price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (selectedFoods.containsKey(food)) {
                          selectedFoods[food] = selectedFoods[food]! - 1;
                        } else {
                          selectedFoods[food] = 1;
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    )),
                Text(
                  selectedFoods.containsKey(food)
                      ? selectedFoods[food].toString()
                      : '0',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (selectedFoods.containsKey(food)) {
                          selectedFoods[food] = selectedFoods[food]! + 1;
                        } else {
                          selectedFoods[food] = 1;
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.add_rounded,
                      color: Color.fromARGB(255, 5, 27, 153),
                    ))
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 5, 27, 153),
        onPressed: () {
          _showCartDialog();
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  void _showCartDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Selected Items'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: selectedFoods.entries.map((entry) {
            final food = entry.key;
            final quantity = entry.value;
            return Text('${food.name} - Quantity: $quantity');
          }).toList(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
            Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
            TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToDeliveryScreen(selectedFoods, widget.restaurant.location);
            },
            child: const Text('Proceed to Delivery'),
          )
        ],
      );
    },
  );
}

void _navigateToDeliveryScreen(Map<Food, int> selectedFoods, Location location) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DeliveryScreen(selectedFoods: selectedFoods, location: location,),
    ),
  );
}
}

void _showEditDialog(BuildContext context, Food food) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Food'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Food name',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'price'
              ),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform the update/delete logic here
              Navigator.pop(context);
            },
            child: const Text('Save Changes'),
          ),
        ],
      );
    },
  );
}


