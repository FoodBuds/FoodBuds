import 'package:flutter/material.dart';

import 'chat_page.dart';

class DateMenuPage extends StatelessWidget {
  final String? locationName;
  final String? closingTime;
  final String? description;
  final String image;

  const DateMenuPage({
    super.key,
    this.locationName,
    this.closingTime,
    this.description,
    this.image = 'assets/coffee_shop.jpg', // Default image if none provided
  });

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
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              locationName ?? 'Default Location Name',
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
            if (closingTime != null) ...[
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
                      'Closed at: $closingTime',
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
                description ?? 'A default description of the location.',
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatPage(),
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
