import 'package:flutter/material.dart';

class ProfileDetail extends StatelessWidget {
  final Map<String, String> user;

  ProfileDetail({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user['name']} ${user['surname']}'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50, // Profile image outside the box
              backgroundImage: AssetImage(user['image']!),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      '${user['name']} ${user['surname']}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBlurredInfoContainer(
                    'Gender: ${user['gender']}',
                  ),
                  const SizedBox(height: 10),
                  _buildBlurredInfoContainer(
                    'Distance: ${user['distance']}',
                  ),
                  const SizedBox(height: 10),
                  _buildBlurredInfoContainer(
                    'City: ${user['city']}',
                  ),
                  const SizedBox(height: 10),
                  _buildBlurredInfoContainer(
                    'Bio: ${user['bio'] ?? 'No bio available'}',
                  ),
                  const SizedBox(height: 10),
                  _buildBlurredInfoContainer(
                    'Diet: ${user['diet'] ?? 'No diet preference'}',
                  ),
                  const SizedBox(height: 10),
                  _buildBlurredInfoContainer(
                    'Gender Preference: ${user['genderPreference'] ?? 'No gender preference'}',
                  ),
                  const SizedBox(height: 10),
                  _buildBlurredInfoContainer(
                    'Favorite Cuisines: ${(user['cuisine'] ?? 'No favorite cuisines').split(',').join(', ')}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlurredInfoContainer(String text) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
