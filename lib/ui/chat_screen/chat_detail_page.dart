import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbuds0_1/ui/chat_screen/chat_screens.dart';
import 'package:foodbuds0_1/repositories/repositories.dart';
import 'package:foodbuds0_1/models/models.dart';

class ChatDetailPage extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String receiverId;

  const ChatDetailPage({
    required this.name,
    required this.imageUrl,
    required this.receiverId,
  });

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();
  String? senderId;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    try {
      senderId = await AuthenticationRepository().getUserId() as String;
    } catch (error) {
      print(error);
    }
  }

  void _handleSend() async {
    if (_controller.text.isNotEmpty) {
      String message = _controller.text;
      _controller.clear(); // Clear the text field
      await ChatRepository().sendMessage(widget.receiverId, message);
    }
  }

  Stream<QuerySnapshot> _messageStream() {
    try {
      return ChatRepository().getMessages(widget.receiverId)
          as Stream<QuerySnapshot>;
    } catch (err) {
      print(err);
      return Stream<QuerySnapshot>.empty();
    }
  }

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
              backgroundImage: NetworkImage(widget.imageUrl),
            ),
            const SizedBox(width: 8),
            Text(
              widget.name,
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
            child: StreamBuilder<QuerySnapshot>(
              stream: _messageStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No messages yet."));
                }

                var messages = snapshot.data!.docs.map((doc) {
                  return Message(
                    senderId: doc['senderId'],
                    senderName: doc['senderName'],
                    receiverId: doc['receiverId'],
                    timestamp: doc['timestamp'],
                    message: doc['message'],
                  );
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isMe = message.senderId == senderId;
                    return MessageBubble(
                      isMe: isMe,
                      text: message.message,
                      time: message.timestamp.toDate().toString(),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ChatInputField(
              controller: _controller,
              onSend: _handleSend,
            ),
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
          color: isMe ? Colors.white : Colors.blue,
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
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: TextStyle(color: Colors.black),
            controller: controller,
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
          onPressed: onSend,
        ),
      ],
    );
  }
}
