import 'package:flutter/material.dart';
import 'package:foodbuds0_1/ui//chat_screen/chat_screens.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationThickness: 2.0,
            decorationColor: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: ListView(
        children: [
          ChatTile(
            name: 'Silvia',
            message: "I'm not a hoarder but I really...",
            time: '11:30',
            imageUrl: 'assets/silvia.png', // Add correct path to the image asset
          ),
          ChatTile(
            name: 'Lucy',
            message: 'Is your body from McDonalds',
            time: '13:51',
            imageUrl: 'assets/lucy1.png', // Add correct path to the image asset
          ),
          ChatTile(
            name: 'Lucy',
            message: 'Is your body from McDonalds',
            time: '13:51',
            imageUrl: 'assets/lucy2.png', // Add correct path to the image asset
          ),
          ChatTile(
            name: 'Lucy',
            message: 'Is your body from McDonalds',
            time: '13:51',
            imageUrl: 'assets/lucy3.png', // Add correct path to the image asset
          ),
        ],
      ),
    );
  }
}



class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String imageUrl;

  const ChatTile({
    required this.name,
    required this.message,
    required this.time,
    required this.imageUrl,
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
          backgroundImage: AssetImage(imageUrl),
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          message,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Text(time),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailPage(name: name, imageUrl: imageUrl),
            ),
          );
        },
      ),
    );
  }
}
