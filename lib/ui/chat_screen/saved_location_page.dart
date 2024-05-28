import 'package:flutter/material.dart';
import 'package:foodbuds0_1/ui//chat_screen/chat_screens.dart';

class SavedLocationsPage extends StatelessWidget {
  const SavedLocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20), // Add spacing to replace the AppBar
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select a location',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved Locations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Sample data for now, replace with dynamic data from backend later
                  ..._buildLocationList(),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DateMenuPage(),
                ));
              },
              child: Text(
                'SELECT DATE START TIME',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.local_pizza, color: Colors.black, size: 30),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLocationList() {
    List<Map<String, String>> locations = [
      {
        'name': 'WILLY\'S',
        'image': 'assets/location1.jpg',
        'hours': 'Open - Closed at: 12:00 PM',
      },
      {
        'name': 'LOVER\'S REST',
        'image': 'assets/location2.jpg',
        'hours': 'Open - Closed at: 1:00 AM',
      },
    ];

    return locations.map((location) {
      return Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                location['image']!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              location['name']!,
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.green),
                    SizedBox(width: 5),
                    Text(
                      location['hours']!,
                      style: TextStyle(color: Colors.amber),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Icon(Icons.arrow_forward, color: Colors.black),
          ),
          Divider(color: Colors.black),
        ],
      );
    }).toList();
  }
}
