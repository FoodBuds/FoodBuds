import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodbuds0_1/ui/authentication_screen/authentication_screen.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';
import 'package:foodbuds0_1/ui/profile_creation/alert.dart';
import 'dart:io';
import 'package:foodbuds0_1/repositories/repositories.dart';
import 'home_screens.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:foodbuds0_1/models/models.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthenticationRepository _authRepo;
  late DatabaseRepository _databaseRepo;
  auth.User? _currentUser;
  bool _isLoading = true;

  String name = '';
  String email = '';
  String currentPlan = 'Free';
  String showMe = 'Men';
  String preferredLanguage = 'English';
  bool isEditing = false;
  bool isEditingPlan = false;
  double ageRangeStart = 22;
  double ageRangeEnd = 34;
  double maxDistance = 100;
  int _selectedSubscriptionIndex = -1;

  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authRepo = AuthenticationRepository();
    _databaseRepo = DatabaseRepository();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? userId = await _authRepo.getUserId();
      if (userId != null) {
        model.User user = await _databaseRepo.getUser(userId).first;
        setState(() {
          name = user.name;
          email = _authRepo.currentUser?.email ?? '';
          _emailController.text = email;
          showMe = user.genderPreference.toString().split('.').last;
          preferredLanguage = user.diet.toString().split('.').last;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> deleteUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? userId = await _authRepo.getUserId();
      if (userId != null) {
        await _databaseRepo.deleteUser(userId);
        await _authRepo.deleteUser();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FirstScreen()),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _editPlanSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Plan Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () => {
                  _onSubscriptionSelected(0),
                  currentPlan = 'Premium - Diamond'
                },
                child: Column(
                  children: [
                    Text(
                      '12 months - \$7/mo',
                      style: TextStyle(
                        color: _selectedSubscriptionIndex == 0
                            ? Colors.blue
                            : Colors.white,
                        fontWeight: _selectedSubscriptionIndex == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => {
                  _onSubscriptionSelected(1),
                  currentPlan = 'Premium - Gold'
                },
                child: Column(
                  children: [
                    Text(
                      '6 months - \$10/mo',
                      style: TextStyle(
                        color: _selectedSubscriptionIndex == 1
                            ? Colors.blue
                            : Colors.white,
                        fontWeight: _selectedSubscriptionIndex == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => {
                  _onSubscriptionSelected(2),
                  currentPlan = 'Premium - Silver'
                },
                child: Column(
                  children: [
                    Text(
                      '1 month - \$19/mo',
                      style: TextStyle(
                        color: _selectedSubscriptionIndex == 2
                            ? Colors.blue
                            : Colors.white,
                        fontWeight: _selectedSubscriptionIndex == 2
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onSubscriptionSelected(int index) {
    setState(() {
      _selectedSubscriptionIndex = index;
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LikePage()), // current page
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  void _changeShowMeOption() async {
    String? selectedOption = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Show me'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Men');
              },
              child: const Text('Men'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Women');
              },
              child: const Text('Women'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Everyone');
              },
              child: const Text('Everyone'),
            ),
          ],
        );
      },
    );

    if (selectedOption != null) {
      setState(() {
        showMe = selectedOption;
      });
    }
  }

  void _changeLanguage() async {
    String? selectedLanguage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Language'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Afrikaans');
              },
              child: const Text('Afrikaans'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Akan');
              },
              child: const Text('Akan'),
            ),
            // Add more language options here...
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'English');
              },
              child: const Text('English'),
            ),
          ],
        );
      },
    );

    if (selectedLanguage != null) {
      setState(() {
        preferredLanguage = selectedLanguage;
      });
    }
  }

  void _validateAndSave() {
    final String email = _emailController.text;

    final bool isValidEmail = email.contains('@');

    if (isValidEmail) {
      setState(() {
        this.email = email;
        isEditing = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content: Text('Please enter a valid email'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.amber,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('images/user.png'),
                        ),
                        const SizedBox(height: 8),
                        Text('$name',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        ProfileSection(
                          title: 'Account Settings',
                          isEditable: true,
                          onEdit: () {
                            setState(() {
                              isEditing = !isEditing;
                            });
                          },
                          children: [
                            isEditing
                                ? ProfileEditableField(
                                    label: 'Name',
                                    value: name,
                                    onChanged: (value) {
                                      setState(() {
                                        name = value;
                                      });
                                    },
                                  )
                                : ProfileDisplayField(
                                    label: 'Name', value: name),
                            isEditing
                                ? ProfileEditableField(
                                    label: 'Email',
                                    value: _emailController.text,
                                    onChanged: (value) {
                                      setState(() {
                                        _emailController.text = value;
                                      });
                                    },
                                  )
                                : ProfileDisplayField(
                                    label: 'Email', value: email),
                            if (isEditing)
                              ElevatedButton(
                                onPressed: _validateAndSave,
                                child: Text('Save'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.amber,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(color: Colors.amber),
                                ),
                              ),
                          ],
                        ),
                        const Divider(thickness: 1),
                        ProfileSection(
                          title: 'Plan Settings',
                          isEditable: true,
                          onEdit: _editPlanSettings,
                          children: [
                            isEditingPlan
                                ? ProfileEditableField(
                                    label: 'Current Plan',
                                    value: currentPlan,
                                    onChanged: (value) {
                                      setState(() {
                                        currentPlan = value;
                                      });
                                    },
                                  )
                                : ProfileDisplayField(
                                    label: 'Current Plan',
                                    value: currentPlan,
                                    isEditable: false),
                          ],
                        ),
                        const Divider(thickness: 1),
                        ProfileSection(
                          title: 'Discovery Settings',
                          children: [
                            const ProfileDisplayField(
                                label: 'Location',
                                value: 'My Current Location',
                                isEditable: false),
                            ProfileDisplayField(
                              label: 'Preferred Languages',
                              value: preferredLanguage,
                              onTap: _changeLanguage,
                            ),
                            ProfileDisplayField(
                              label: 'Show Me',
                              value: showMe,
                              onTap: _changeShowMeOption,
                            ),
                            ProfileRangeField(
                              label: 'Age Range',
                              start: ageRangeStart,
                              end: ageRangeEnd,
                              min: 18,
                              max: 60,
                              onChanged: (RangeValues values) {
                                setState(() {
                                  ageRangeStart = values.start;
                                  ageRangeEnd = values.end;
                                });
                              },
                            ),
                            ProfileRangeField(
                              label: 'Maximum Distance',
                              start: 0,
                              end: maxDistance,
                              min: 0,
                              max: 200,
                              onChanged: (RangeValues values) {
                                setState(() {
                                  maxDistance = values.end;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1),
                  ElevatedButton(
                    onPressed: () {
                      AuthenticationRepository().signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FirstScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white),
                    child: const Text('Logout'),
                  ),
                  const SizedBox(height: 8), // Added space between buttons
                  ElevatedButton(
                    onPressed: () async => deleteUser(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white),
                    child: const Text('Delete Account'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Likes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 3, // Assuming Profile is the current page
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isEditable;
  final VoidCallback? onEdit;

  const ProfileSection({
    required this.title,
    required this.children,
    this.isEditable = false,
    this.onEdit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              if (isEditable)
                TextButton(
                  onPressed: onEdit,
                  child:
                      const Text('Edit', style: TextStyle(color: Colors.blue)),
                ),
            ],
          ),
          ...children,
        ],
      ),
    );
  }
}

class ProfileDisplayField extends StatelessWidget {
  final String label;
  final String value;
  final bool isEditable;
  final VoidCallback? onTap;

  const ProfileDisplayField({
    required this.label,
    required this.value,
    this.isEditable = true,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: TextStyle(color: Colors.black)),
      subtitle: Text(value, style: TextStyle(color: Colors.black)),
      trailing: isEditable
          ? IconButton(icon: Icon(Icons.edit), onPressed: onTap)
          : null,
      onTap: onTap,
    );
  }
}

class ProfileEditableField extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const ProfileEditableField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: value);
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));

    return ListTile(
      title: Text(label, style: TextStyle(color: Colors.black)),
      subtitle: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
      ),
    );
  }
}

class ProfileRangeField extends StatelessWidget {
  final String label;
  final double start;
  final double end;
  final double min;
  final double max;
  final Function(RangeValues) onChanged;

  const ProfileRangeField({
    required this.label,
    required this.start,
    required this.end,
    required this.min,
    required this.max,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: TextStyle(color: Colors.black)),
      subtitle: RangeSlider(
        values: RangeValues(start, end),
        min: min,
        max: max,
        onChanged: onChanged,
        activeColor: Colors.amber,
        inactiveColor: Colors.black12,
      ),
    );
  }
}
