import 'package:flutter/material.dart';
import 'package:foodbuds0_1/ui/chat_screen/date_location_page.dart';


class ChatDetailPage extends StatelessWidget {
  final String name;
  final String imageUrl;

  const ChatDetailPage({
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LocationSelectionPage(),
              ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                MessageBubble(
                  isMe: false,
                  text: "Can I follow you? Cause my mom told me to follow my dreams...",
                  time: "12:05",
                  isHighlighted: true,
                ),
                MessageBubble(
                  isMe: true,
                  text: "I'm not a hoarder but I really Lorem ips",
                  time: "12:06",
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ChatInputField(),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  final String time;
  final bool isHighlighted;

  const MessageBubble({
    required this.isMe,
    required this.text,
    required this.time,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.white : Colors.blue,  // Change shade for better visibility
          borderRadius: BorderRadius.circular(15.0),
          border: isMe ? Border.all(color: Colors.grey[300]!, width: 1) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.black : Colors.white,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              time,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Type Something...',
              hintStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              fillColor: Colors.grey[200],
              filled: true,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send, color: Colors.black),
          onPressed: () {

          },
        ),
      ],
    );
  }
}
