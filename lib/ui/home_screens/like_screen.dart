import 'package:flutter/material.dart';
import 'package:foodbuds0_1/models/user_model.dart';
import 'package:foodbuds0_1/repositories/authentication_repository.dart';
import 'package:foodbuds0_1/repositories/database_repository.dart';
import '../home_screens/profiledetail_screen.dart'; // Import the ProfileDetail page

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  List<User> _superLikedByUsers = [];
  bool _isLoading = true;
  final DatabaseRepository _databaseRepository = DatabaseRepository();

  @override
  void initState() {
    super.initState();
    _fetchSuperLikedByUsers();
  }

  Future<void> _fetchSuperLikedByUsers() async {
    setState(() {
      _isLoading = true;
    });

    String? userId = await AuthenticationRepository().getUserId();
    if (userId != null) {
      List<User> users = await _databaseRepository.getSuperLikedByUsers(userId);
      setState(() {
        _superLikedByUsers = users;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text('    Likes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28)),
        elevation: 0, // Remove the shadow
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _superLikedByUsers.isEmpty
          ? Center(child: Text('No one is here yet'))
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5, // Adjusted to make images smaller
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: _superLikedByUsers.length,
        itemBuilder: (context, index) {
          User user = _superLikedByUsers[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileDetail(user: user),
                ),
              );
            },
            child: Stack(
              children: [
                Image.network(
                  user.filePath ?? 'images/blurred.png',
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.5),
                  colorBlendMode: BlendMode.darken,
                ),
                Center(
                  child: Text(
                    user.name,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
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


/*
import 'package:flutter/material.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  bool _showSubscriptionPrompt = false;
  int _selectedSubscriptionIndex = -1;

  void _onLikeTapped() {
    setState(() {
      _showSubscriptionPrompt = true;
    });
  }

  void _onSubscriptionSelected(int index) {
    setState(() {
      _selectedSubscriptionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text('    Likes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28)),
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
                            onPressed: () {
                              // Handle subscription
                              setState(() {
                                _showSubscriptionPrompt = false;
                              });
                            },
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