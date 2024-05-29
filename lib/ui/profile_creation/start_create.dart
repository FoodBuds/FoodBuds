import 'package:flutter/material.dart';
import 'package:foodbuds0_1/ui/profile_creation/add_photo.dart';
import 'profile_creation.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';

class StartCreate extends StatefulWidget {
  @override
  _StartCreateState createState() => _StartCreateState();
}

class _StartCreateState extends State<StartCreate> {
  final _formKey = GlobalKey<FormState>();
  final AuthenticationRepository _authRepository = AuthenticationRepository();

  String? _id;
  String _name = '';
  String _surname = '';
  String _aboutme = '';
  String _gender = '';

  @override
  void initState() {
    super.initState();
    _fetchId();
  }

  void _fetchId() async {
    final id = await _authRepository.getUserId();
    setState(() {
      _id = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: Text(
          'Let\'s start creating your profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                buildInputField(
                  label: 'Name*',
                  hint: 'John',
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                const SizedBox(height: 20),
                buildInputField(
                  label: 'Surname*',
                  hint: 'Doe',
                  onChanged: (value) {
                    _surname = value;
                  },
                ),
                const SizedBox(height: 25),
                buildGenderField(context),
                const SizedBox(height: 25),
                buildInputField(
                  label: 'About Me*',
                  hint: 'Hi! I\'m using FoodbuD',
                  maxLines: 3,
                  onChanged: (value) {
                    _aboutme = value;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddPhotoPage(
                          data: {
                            'id': _id,
                            'name': _name,
                            'surname': _surname,
                            'gender': _gender,
                            'aboutme': _aboutme,
                          },
                        ),
                      ));
                    }
                  },
                  child:
                      Text('CONTINUE', style: TextStyle(color: Colors.amber)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
      {required String label,
      required String hint,
      required Function(String) onChanged,
      int maxLines = 1}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: onChanged,
        style: TextStyle(color: Colors.black),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildGenderField(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 200,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Male'),
                    onTap: () {
                      setState(() {
                        _gender = 'Male';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Female'),
                    onTap: () {
                      setState(() {
                        _gender = 'Female';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gender',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            Text(
              _gender,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
