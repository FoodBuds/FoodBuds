import 'package:flutter/material.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';
import 'package:foodbuds0_1/repositories/database_repository.dart';
import 'package:foodbuds0_1/models/models.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  User? user1;
  User? user2;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      User fetchedUser1 = await DatabaseRepository()
          .getUser('2KbQ4xZKapSbhNipuNgrTCiPHsU2')
          .first;
      User fetchedUser2 = await DatabaseRepository()
          .getUser('JpALCk2ZYFgZMrJSGOyRy8YtDM52')
          .first;
      setState(() {
        user1 = fetchedUser1;
        user2 = fetchedUser2;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '    Chat',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28)
        ),
        backgroundColor: Colors.amber,
      ),
      body: user1 == null || user2 == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ChatTile(
                  user: user1!,
                ),
                ChatTile(
                  user: user2!,
                ),
              ],
            ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final User user;

  const ChatTile({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.filePath as String),
        ),
        title: Text(
          user.name,
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          "message",
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Text("time"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailPage(
                name: user.name,
                imageUrl: user.filePath as String,
                receiverId: user.id as String,
              ),
            ),
          );
        },
      ),
    );
  }
}
