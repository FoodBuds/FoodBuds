import 'package:flutter/material.dart';
import 'package:foodbuds0_1/models/models.dart';
import 'package:foodbuds0_1/repositories/chat_repository.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_page.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';

class DateMenuPage extends StatelessWidget {
  final Restaurant restaurant;
  final String receiverId;
  final String name;
  final String imageUrl;

  const DateMenuPage({
    super.key,
    required this.restaurant,
    required this.receiverId,
    required this.name,
    required this.imageUrl,
  });

  Future<void> sendDateMessage() async {
    await ChatRepository().sendDatingMessage(receiverId, restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                restaurant.filePath ??
                    'images/American.png', // Default image if none provided
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              restaurant.restaurantName ?? 'Default Location Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow[700], size: 30),
                Icon(Icons.star, color: Colors.yellow[700], size: 30),
                Icon(Icons.star, color: Colors.yellow[700], size: 30),
                Icon(Icons.star, color: Colors.yellow[700], size: 30),
                Icon(Icons.star_border, color: Colors.yellow[700], size: 30),
              ],
            ),
            SizedBox(height: 10),
            if (restaurant.closingHour != null) ...[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.access_time, color: Colors.black),
                    SizedBox(width: 5),
                    Text(
                      'Closed at: ${restaurant.closingHour}',
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'A default description of the location.',
                style: TextStyle(color: Colors.amber),
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(color: Colors.amber),
              ),
              onPressed: () {
                sendDateMessage();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatDetailPage(
                      name: name, imageUrl: imageUrl, receiverId: receiverId),
                ));
              },
              child: Text(
                'ASK FOR A DATE',
                style: TextStyle(fontSize: 18, color: Colors.amber),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
