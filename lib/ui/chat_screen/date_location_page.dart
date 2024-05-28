import 'package:flutter/material.dart';
import 'package:foodbuds0_1/ui/chat_screen/date_menu_screen.dart';

class LocationSelectionPage extends StatefulWidget {
  const LocationSelectionPage({super.key});

  @override
  State<LocationSelectionPage> createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  String? currentLocationName;
  String? currentLocationHours;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.bookmark_border, color: Colors.black),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SavedLocationsWidget(
                      onSelect: (name, hours) {
                        setState(() {
                          currentLocationName = name;
                          currentLocationHours = hours;
                        });
                      },
                    ),
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                  );
                },
              ),
            ),
            Text(
              'Select a location',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            ClipOval(
              child: Image.asset(
                'images/map.png',
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 30),
            if (currentLocationName != null) ...[
              Text(
                currentLocationName!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              if (currentLocationHours != null) ...[
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
                    currentLocationHours!,
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
                if (currentLocationName == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a location first.'),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DateMenuPage(
                        locationName: currentLocationName,
                        closingTime: currentLocationHours,
                        description: 'A cozy place to enjoy coffee and snacks.', // Example description
                      ),
                    ),
                  );
                }
              },
              child: Text('Ask for a date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.amber,
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

class SavedLocationsWidget extends StatelessWidget {
  final List<Map<String, String>> locations = [
    {
      'name': 'WILLY\'S',
      'image': 'assets/location1.jpg',
      'hours': 'Closed at: 12:00 PM',
    },
    {
      'name': 'LOVER\'S REST',
      'image': 'assets/location2.jpg',
      'hours': 'Closed at: 1:00 AM',
    },
  ];

  final Function(String, String) onSelect;

  SavedLocationsWidget({required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Saved Locations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                var location = locations[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      location['image'] ?? 'assets/default.jpg',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    location['name'] ?? 'Unknown',
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.green),
                      SizedBox(width: 5),
                      Text(
                        location['hours'] ?? 'No hours available',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward, color: Colors.black),
                  onTap: () {
                    onSelect(location['name']!, location['hours']!);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
