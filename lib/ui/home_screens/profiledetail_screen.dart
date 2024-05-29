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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6, // Profile image covers most of the screen
              width: double.infinity,
              child: Image.asset(
                user['image']!,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        '${user['name']} ${user['surname']}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoText('Gender: ${user['gender']}'),
                    const Divider(),
                    _buildInfoText('City: ${user['city']}'),
                    const Divider(),
                    _buildInfoText('Bio: ${user['bio'] ?? 'No bio available'}'),
                    const Divider(),
                    _buildInfoText('Diet: ${user['diet'] ?? 'No diet preference'}'),
                    const Divider(),
                    _buildInfoText('Gender Preference: ${user['genderPreference'] ?? 'No gender preference'}'),
                    const Divider(),
                    _buildInfoText('Favorite Cuisines: ${(user['cuisine'] ?? 'No favorite cuisines').split(',').join(', ')}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Color.fromRGBO(0, 1, 39, 1),
        ),
      ),
    );
  }
}
