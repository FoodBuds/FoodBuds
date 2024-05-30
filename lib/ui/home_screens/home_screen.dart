import 'package:flutter/material.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';
import 'package:foodbuds0_1/repositories/database_repository.dart';
import 'home_screens.dart';
import 'package:foodbuds0_1/models/user_model.dart' as model;
import 'package:foodbuds0_1/repositories/authentication_repository.dart';

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
        iconSize: 30,
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

  List<model.User> _users = [];
  final DatabaseRepository _databaseRepository = DatabaseRepository();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    List<String> userIds = await _databaseRepository.matchUsers();
    List<model.User> users = [];
    for (String userId in userIds) {
      model.User? user = await _databaseRepository.getUserById(userId);
      if (user != null) {
        users.add(user);
      }
    }
    setState(() {
      _users = users;
    });
  }

  Future<void> _likeUser(String likedUserId) async {
    String? likerUserId = await AuthenticationRepository().getUserId();
    if (likerUserId != null) {
      await _databaseRepository.likeUser(likerUserId, likedUserId);
      bool isMatch = await _databaseRepository.checkForMatch(likerUserId, likedUserId);
      if (isMatch) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MatchPage(),
        ));
      }
    }
  }

  Future<void> _dislikeUser(String dislikedUserId) async {
    String? dislikerUserId = await AuthenticationRepository().getUserId();
    if (dislikerUserId != null) {
      await _databaseRepository.dislikeUser(dislikerUserId, dislikedUserId);
    }
  }

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
                _fetchUsers(); // Re-fetch users based on the applied filter
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
          title: const Text('Explain why you would report this user'),
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
    if (_users.isNotEmpty) {
      String dislikedUserId = _users.first.id!;
      _dislikeUser(dislikedUserId);
      setState(() {
        _users.removeAt(0);
      });
    }
  }

  void _swipeRight() async {
    if (_users.isNotEmpty) {
      String likedUserId = _users.first.id!;
      await _likeUser(likedUserId);
      setState(() {
        _users.removeAt(0);
      });
    }
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
      body: _users.isEmpty
          ? const Center(child: Text('No more users'))
          : LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                model.User currentUser = _users.first;
                return Container(
                  color: Colors.amber,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileDetail(user: currentUser),
                            ));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: constraints.maxHeight * 0.1),
                              Image.asset(
                                'images/user.png', // User profile image
                                fit: BoxFit.cover,
                                width: constraints.maxWidth * 0.9,
                                height: constraints.maxHeight * 0.55,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                margin: const EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${currentUser.name} ${currentUser.surname}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      currentUser.city,
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0), // Increase the padding to move buttons higher
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CircleAvatar(
                              radius: constraints.maxWidth * 0.1, // Increase circle avatar size
                              backgroundColor: Colors.red,
                              child: IconButton(
                                icon: const Icon(Icons.clear, color: Colors.white),
                                onPressed: _swipeLeft,
                              ),
                            ),
                            CircleAvatar(
                              radius: constraints.maxWidth * 0.1, // Increase circle avatar size
                              backgroundColor: Colors.blue,
                              child: IconButton(
                                icon: const Icon(Icons.favorite, color: Colors.white),
                                onPressed: _showSuperLikeMessage,
                              ),
                            ),
                            CircleAvatar(
                              radius: constraints.maxWidth * 0.1, // Increase circle avatar size
                              backgroundColor: Colors.green,
                              child: IconButton(
                                icon: const Icon(Icons.check, color: Colors.white),
                                onPressed: _swipeRight,
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
