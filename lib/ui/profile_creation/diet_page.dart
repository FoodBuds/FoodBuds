import 'package:flutter/material.dart';
import 'show_me_gender.dart';

class DietPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const DietPage({Key? key, required this.data}) : super(key: key);

  @override
  _DietDocState createState() => _DietDocState();
}

class _DietDocState extends State<DietPage> {
  String _selectedDiet = '';

  final Map<String, String> _dietIcons = {
    'Herbivore': 'images/Steak.png',
    'Vegetarian': 'images/Eggs.png',
    'Vegan': 'images/Apple.png',
    'Pescatarian': 'images/Fish.png',
    'Flexitarian': 'images/Sashimi.png',
  };

  void _handleDietSelection(String value) {
    setState(() {
      _selectedDiet = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text('What do you eat?',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      body: ListView(
        children: _dietIcons.keys.map((String key) {
          return Card(
            color: _selectedDiet == key ? Colors.green : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              title: Text(key, style: const TextStyle(color: Colors.black)),
              trailing: Image.asset(_dietIcons[key]!),
              onTap: () {
                _handleDietSelection(key);
              },
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShowMeGenderPage(
              data: {
                ...widget.data,
                'diet': _selectedDiet,
              },
            ),
          ));
        },
        label: const Text('Continue'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}
