import 'package:flutter/material.dart';
import 'package:foodbuds0_1/models/models.dart';
import 'package:foodbuds0_1/repositories/repositories.dart';
import 'package:foodbuds0_1/repositories/restaurant_repository.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';

class RestaurantSelectionPage extends StatefulWidget {
  final String receiverId;
  final String name;
  final String imageUrl;

  const RestaurantSelectionPage({
    super.key,
    required this.receiverId,
    required this.name,
    required this.imageUrl,
  });

  @override
  State<RestaurantSelectionPage> createState() =>
      _RestaurantSelectionPageState();
}

class _RestaurantSelectionPageState extends State<RestaurantSelectionPage> {
  Restaurant? selectedRestaurant;

  final List<Restaurant> restaurants = RestaurantRepository().getRestaurants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Restaurant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  var restaurant = restaurants[index];
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                restaurant.filePath ?? 'assets/default.jpg',
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              restaurant.restaurantName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.green),
                                SizedBox(width: 5),
                                Text(
                                  restaurant.closingHour,
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing:
                            Icon(Icons.arrow_forward, color: Colors.black),
                        onTap: () {
                          setState(() {
                            selectedRestaurant = restaurant;
                          });
                        },
                      ),
                      Divider(color: Colors.black),
                    ],
                  );
                },
              ),
            ),
            if (selectedRestaurant != null) ...[
              Text(
                selectedRestaurant!.restaurantName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              if (selectedRestaurant!.closingHour != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    selectedRestaurant!.closingHour,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.amber,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ],
            ElevatedButton(
              onPressed: () {
                if (selectedRestaurant == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a restaurant first.'),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DateMenuPage(
                        restaurant: selectedRestaurant!,
                        receiverId: widget.receiverId,
                        name: widget.name,
                        imageUrl: widget.imageUrl,
                      ),
                    ),
                  );
                }
              },
              child: Text('Ask for a date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                textStyle: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
