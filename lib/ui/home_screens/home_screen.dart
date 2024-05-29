import 'package:flutter/material.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';
import 'home_screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const <Widget>[
          HomeScreenContent(),
          ChatPage(),
          LikePage(),
          ProfilePage(),
        ],
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  double _distance = 5.0;
  String _gender = 'Male';
  RangeValues _ageRange = const RangeValues(22, 34);
  int _userIndex = 0;

final List<Map<String, String>> _users = [
  {
    'name': 'Rex',
    'surname': 'Doe',
    'gender': 'Male',
    'bio': 'I love hiking and outdoor activities.',
    'diet': 'Vegetarian',
    'genderPreference': 'Female',
    'cuisine': 'Italian, Mexican, Chinese',
    'city': 'New York',
    'distance': '5 miles',
    'image': 'images/user.png'
  },
  {
    'name': 'Anna',
    'surname': 'Smith',
    'gender': 'Female',
    'bio': 'I am a foodie and love trying new recipes.',
    'diet': 'Non-Vegetarian',
    'genderPreference': 'Male',
    'cuisine': 'Japanese, Thai, Indian',
    'city': 'San Francisco',
    'distance': '3 miles',
    'image': 'images/user2.png'
  },
  // Add more users here
];

  final PageController _pageController = PageController();

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Distance'),
                  Slider(
                    value: _distance,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: '${_distance.toInt()} km',
                    onChanged: (double value) {
                      setState(() {
                        _distance = value;
                      });
                    },
                  ),
                  const Text('Gender'),
                  Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: _gender,
                        onChanged: (String? value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: _gender,
                        onChanged: (String? value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const Text('Age'),
                  RangeSlider(
                    values: _ageRange,
                    min: 18,
                    max: 60,
                    divisions: 42,
                    labels: RangeLabels(
                      _ageRange.start.round().toString(),
                      _ageRange.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _ageRange = values;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Explain why would you report this user'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Report',
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showSuperLikeMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Super like sent'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _swipeLeft() {
    setState(() {
      _userIndex = (_userIndex + 1) % _users.length;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  void _swipeRight() {
    setState(() {
      _userIndex = (_userIndex + 1) % _users.length;
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.report_problem, color: Colors.black),
            onPressed: _showReportDialog,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _users.length,
                    onPageChanged: (index) {
                      setState(() {
                        _userIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfileDetail(user: _users[index]),
                          ));
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 20), // Add some space above the image
                            Image.asset(
                              _users[index]['image']!, // User profile image
                              fit: BoxFit.cover,
                              width: constraints.maxWidth * 0.9,
                              height: constraints.maxHeight * 0.5,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _users[index]['name']!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _users[index]['distance']!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        radius: constraints.maxWidth * 0.08,
                        backgroundColor: Colors.red,
                        child: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: _swipeRight,
                        ),
                      ),
                      CircleAvatar(
                        radius: constraints.maxWidth * 0.08,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.white),
                          onPressed: _showSuperLikeMessage,
                        ),
                      ),
                      CircleAvatar(
                        radius: constraints.maxWidth * 0.08,
                        backgroundColor: Colors.green,
                        child: IconButton(
                          icon: const Icon(Icons.check, color: Colors.white),
                          onPressed: _swipeLeft,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
