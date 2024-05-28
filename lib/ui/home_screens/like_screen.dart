import 'package:flutter/material.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';
import 'package:foodbuds0_1/ui/profile_creation/alert.dart';

import 'home_screens.dart';

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
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                              'Unlimited Super Likes\nSend as many super likes as you want'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildSubscriptionOption(
                                  0, '12 months', '\$7/mo'),
                              _buildSubscriptionOption(
                                  1, '6 months', '\$10/mo'),
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
        currentIndex: 2, // Assuming Likes is the current page
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
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
              color: _selectedSubscriptionIndex == index
                  ? Colors.blue
                  : Colors.black,
              fontWeight: _selectedSubscriptionIndex == index
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: _selectedSubscriptionIndex == index
                  ? Colors.blue
                  : Colors.black,
              fontWeight: _selectedSubscriptionIndex == index
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
