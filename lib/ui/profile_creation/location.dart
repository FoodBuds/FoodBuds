import 'package:flutter/material.dart';
import 'alert.dart';
import 'package:foodbuds0_1/models/models.dart' as model;
import 'package:foodbuds0_1/repositories/repositories.dart';

class LocationPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const LocationPage({Key? key, required this.data}) : super(key: key);

  void updateDataToBackend() {
    try {
      DatabaseRepository().updateUser(data);
    } catch (error) {
      print(error);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Where are you ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset(
              'images/location.png',
              height: 200,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Verileri backend'e gönder
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.amber,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('ENABLE LOCATION'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextButton(
                onPressed: () {
                  updateDataToBackend();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AlertPage(),
                  ));
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                  backgroundColor: Colors.white,
                ),
                child: const Text('SKIP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
