
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../home_screens/profiledetail_screen.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';
import 'package:foodbuds0_1/repositories/database_repository.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  bool _showSubscriptionPrompt = false;
  int _selectedSubscriptionIndex = -1;
  List<User> _likedUsers = [];
  List<User> _dislikedUsers = [];
  bool _isPremiumUser = false;

  @override
  void initState() {
    super.initState();
    _fetchLikedAndDislikedUsers();
    _checkSubscriptionStatus();
  }

  Future<void> _fetchLikedAndDislikedUsers() async {
    String? currentUserId = await AuthenticationRepository().getUserId();
    if (currentUserId != null) {
      List<User> likedUsers = await DatabaseRepository().getUsersWhoLiked(currentUserId);
      List<User> dislikedUsers = await DatabaseRepository().getUsersWhoDisliked(currentUserId);
      setState(() {
        _likedUsers = likedUsers;
        _dislikedUsers = dislikedUsers;
      });
    }
  }

  Future<void> _checkSubscriptionStatus() async {
    String? userId = await AuthenticationRepository().getUserId();
    if (userId != null) {
      bool isPremium = await DatabaseRepository().isPremiumUser(userId);
      setState(() {
        _isPremiumUser = isPremium;
      });
    }
  }

  void _onLikeTapped(User user) {
    if (_isPremiumUser) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileDetail(user: user),
        ),
      );
    } else {
      setState(() {
        _showSubscriptionPrompt = true;
      });
    }
  }

  void _onSubscriptionSelected(int index) {
    setState(() {
      _selectedSubscriptionIndex = index;
    });
  }

  void _onContinuePressed() {
    setState(() {
      _showSubscriptionPrompt = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Likes', style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          _likedUsers.isEmpty && _dislikedUsers.isEmpty
              ? Center(
            child: Text(
              'No users liked or disliked you yet.',
              style: TextStyle(color: Colors.white),
            ),
          )
              : GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: _likedUsers.length + _dislikedUsers.length,
            itemBuilder: (context, index) {
              User user;
              bool isDisliked = false;

              if (index < _likedUsers.length) {
                user = _likedUsers[index];
              } else {
                user = _dislikedUsers[index - _likedUsers.length];
                isDisliked = true;
              }

              return GestureDetector(
                onTap: () => _onLikeTapped(user),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(user.filePath!),
                      fit: BoxFit.cover,
                      colorFilter: isDisliked && !_isPremiumUser
                          ? ColorFilter.mode(Colors.grey, BlendMode.saturation)
                          : null,
                    ),
                  ),
                  child: isDisliked && !_isPremiumUser
                      ? Center(
                    child: Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 40,
                    ),
                  )
                      : null,
                ),
              );
            },
          ),
          if (_showSubscriptionPrompt)
            Center(
              child: Container(
                color: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Get FoodbuD+',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          const Text('Unlimited Super Likes\nSend as many super likes as you want'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildSubscriptionOption(0, '12 months', '\$7/mo'),
                              _buildSubscriptionOption(1, '6 months', '\$10/mo'),
                              _buildSubscriptionOption(2, '1 month', '\$19/mo'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _onContinuePressed,
                            child: const Text('CONTINUE'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOption(int index, String duration, String price) {
    return GestureDetector(
      onTap: () => _onSubscriptionSelected(index),
      child: Column(
        children: [
          Text(
            duration,
            style: TextStyle(
              color: _selectedSubscriptionIndex == index ? Colors.blue : Colors.white,
              fontWeight: _selectedSubscriptionIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: _selectedSubscriptionIndex == index ? Colors.blue : Colors.white,
              fontWeight: _selectedSubscriptionIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../home_screens/profiledetail_screen.dart'; // Import the ProfileDetail page

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  bool _showSubscriptionPrompt = false;
  int _selectedSubscriptionIndex = -1;

  void _onLikeTapped() {
    if (_selectedSubscriptionIndex != -1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileDetail(
            user: User(
              name: 'John',
              surname: 'Doe',
              gender: 'Male',
              city: 'Sample City',
              bio: 'Sample Bio',
              diet: 'Vegetarian',
              genderPreference: 'Female',
              cuisine: [],
            ),
          ),
        ),
      );
    } else {
      setState(() {
        _showSubscriptionPrompt = true;
      });
    }
  }

  void _onSubscriptionSelected(int index) {
    setState(() {
      _selectedSubscriptionIndex = index;
    });
  }

  void _onContinuePressed() {
    setState(() {
      _showSubscriptionPrompt = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Likes', style: TextStyle(color: Colors.black)),
        elevation: 0, // Remove the shadow
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.5, // Adjusted to make images smaller
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: 7,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: _onLikeTapped,
                  child: Image.asset(
                    'images/blurred.png', // corrected path to the blurred image
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          if (_showSubscriptionPrompt)
            Center(
              child: Container(
                color: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Get FoodbuD+',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          const Text('Unlimited Super Likes\nSend as many super likes as you want'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildSubscriptionOption(0, '12 months', '\$7/mo'),
                              _buildSubscriptionOption(1, '6 months', '\$10/mo'),
                              _buildSubscriptionOption(2, '1 month', '\$19/mo'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _onContinuePressed,
                            child: const Text('CONTINUE'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOption(int index, String duration, String price) {
    return GestureDetector(
      onTap: () => _onSubscriptionSelected(index),
      child: Column(
        children: [
          Text(
            duration,
            style: TextStyle(
              color: _selectedSubscriptionIndex == index ? Colors.blue : Colors.white,
              fontWeight: _selectedSubscriptionIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: _selectedSubscriptionIndex == index ? Colors.blue : Colors.white,
              fontWeight: _selectedSubscriptionIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
*/


