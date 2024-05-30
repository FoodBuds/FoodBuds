import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:foodbuds0_1/ui/authentication_screen/authentication_screen.dart';
import 'package:foodbuds0_1/repositories/repositories.dart';
import 'package:foodbuds0_1/models/models.dart' as model;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthenticationRepository _authRepo;
  late DatabaseRepository _databaseRepo;
  bool _isLoading = true;

  String name = '';
  String email = '';
  String bio = '';
  String currentPlan = 'Free';
  String showMe = 'Men';
  String diet = 'Herbivore';
  String city = 'Istanbul';
  List<String> cuisine = [];
  String filePath = "";
  bool isEditing = false;
  bool isEditingPlan = false;
  int _selectedSubscriptionIndex = -1;

  File? _profileImage;
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();

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
          bio = user.bio;
          _bioController.text = bio;
          showMe = user.genderPreference.toString().split('.').last;
          diet = user.diet.toString().split('.').last;
          cuisine = user.cuisine;
          filePath = user.filePath as String;
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
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

  void _changeDiet() async {
    String? selectedDiet = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Diet'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Herbivore');
              },
              child: const Text('Herbivore'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Vegetarian');
              },
              child: const Text('Vegetarian'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Vegan');
              },
              child: const Text('Vegan'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Pescatarian');
              },
              child: const Text('Pescatarian'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Flexitarian');
              },
              child: const Text('Flexitarian'),
            ),
          ],
        );
      },
    );

    if (selectedDiet != null) {
      setState(() {
        diet = selectedDiet;
      });
    }
  }

  void _changeCity() async {
    String? selectedCity = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('City'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Adana');
              },
              child: const Text('Adana'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Adıyaman');
              },
              child: const Text('Adıyaman'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Afyonkarahisar');
              },
              child: const Text('Afyonkarahisar'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Ağrı');
              },
              child: const Text('Ağrı'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Aksaray');
              },
              child: const Text('Aksaray'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Istanbul');
              },
              child: const Text('Istanbul'),
            ),
          ],
        );
      },
    );

    if (selectedCity != null) {
      setState(() {
        city = selectedCity;
      });
    }
  }

  void _changeCuisine() async {
    List<String>? selectedCuisines = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        List<String> selected = List.from(cuisine);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Cuisine'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text('Turkish'),
                    value: selected.contains('Turkish'),
                    onChanged: (bool? value) {
                      setState(() {
                        value == true
                            ? selected.add('Turkish')
                            : selected.remove('Turkish');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Italian'),
                    value: selected.contains('Italian'),
                    onChanged: (bool? value) {
                      setState(() {
                        value == true
                            ? selected.add('Italian')
                            : selected.remove('Italian');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('French'),
                    value: selected.contains('French'),
                    onChanged: (bool? value) {
                      setState(() {
                        value == true
                            ? selected.add('French')
                            : selected.remove('French');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Chinese'),
                    value: selected.contains('Chinese'),
                    onChanged: (bool? value) {
                      setState(() {
                        value == true
                            ? selected.add('Chinese')
                            : selected.remove('Chinese');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Japanese'),
                    value: selected.contains('Japanese'),
                    onChanged: (bool? value) {
                      setState(() {
                        value == true
                            ? selected.add('Japanese')
                            : selected.remove('Japanese');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Indian'),
                    value: selected.contains('Indian'),
                    onChanged: (bool? value) {
                      setState(() {
                        value == true
                            ? selected.add('Indian')
                            : selected.remove('Indian');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Mexican'),
                    value: selected.contains('Mexican'),
                    onChanged: (bool? value) {
                      setState(() {
                        value == true
                            ? selected.add('Mexican')
                            : selected.remove('Mexican');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Spanish'),
                    value: selected.contains('Spanish'),
                    onChanged: (bool? value) {
                      setState(() {
                        value == true
                            ? selected.add('Spanish')
                            : selected.remove('Spanish');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Thai'),
                    value: selected.contains('Thai'),
                    onChanged: (bool? value) {
                      setState(() {
                        value == true
                            ? selected.add('Thai')
                            : selected.remove('Thai');
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('American'),
                    value: selected.contains('American'),
                    onChanged: (bool? value) {
                      setState(() {
                        value == true
                            ? selected.add('American')
                            : selected.remove('American');
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    Navigator.pop(context, selected);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedCuisines != null) {
      setState(() {
        cuisine = selectedCuisines;
      });
    }
  }

  void _validateAndSave() async {
    final String email = _emailController.text;
    final String bio = _bioController.text;
    final bool isValidEmail = email.contains('@');

    if (isValidEmail) {
      String? userId = await _authRepo.getUserId();
      if (userId != null) {
        Map<String, dynamic> updatedData = {
          'name': name,
          'email': email,
          'bio': bio,
          'genderPreference': showMe,
          'diet': diet,
          'cuisine': cuisine,
          'filePath': filePath,
          'city': city,
        };
        await _databaseRepo.updateUser(updatedData);
        setState(() {
          this.email = email;
          this.bio = bio;
          isEditing = false;
        });
      }
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
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : (filePath.isNotEmpty
                                        ? (filePath.startsWith('http')
                                            ? NetworkImage(filePath)
                                            : FileImage(File(filePath)))
                                        : AssetImage(
                                            'images/default_profile.png'))
                                    as ImageProvider,
                          ),
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
                            isEditing
                                ? ProfileEditableField(
                                    label: 'Bio',
                                    value: _bioController.text,
                                    onChanged: (value) {
                                      setState(() {
                                        _bioController.text = value;
                                      });
                                    },
                                  )
                                : ProfileDisplayField(
                                    label: 'Bio', value: bio),
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
                            ProfileDisplayField(
                              label: 'City',
                              value: city,
                              onTap: _changeCity,
                            ),
                            ProfileDisplayField(
                              label: 'Diet',
                              value: diet,
                              onTap: _changeDiet,
                            ),
                            ProfileDisplayField(
                              label: 'Show Me',
                              value: showMe,
                              onTap: _changeShowMeOption,
                            ),
                            ProfileDisplayField(
                              label: 'Cuisine',
                              value: cuisine.join(', '),
                              onTap: _changeCuisine,
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
