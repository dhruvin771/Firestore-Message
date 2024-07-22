import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String user;

  ChatScreen(this.user, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String get user => widget.user;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          user,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final chatMessages = snapshot.data!.docs;
                  if (chatMessages.isEmpty) {
                    return const Center(child: Text('No Messages'));
                  }

                  int id = user.contains("Smiley") ? 1 : 2;

                  return ListView.builder(
                    reverse: true,
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      var chatData =
                          chatMessages[index].data() as Map<String, dynamic>;
                      String message = chatData['message'] ?? '';
                      int userId = chatData['userId'] ?? 0;

                      bool isPrevSameId = index < chatMessages.length - 1
                          ? (chatMessages[index + 1].data()
                                  as Map<String, dynamic>)['userId'] ==
                              userId
                          : false;

                      return message.isEmpty
                          ? Container()
                          : BubbleSpecialThree(
                              text: message,
                              color: userId == id
                                  ? const Color(0xFF1B97F3)
                                  : const Color(0xFFE8E8EE),
                              tail: isPrevSameId,
                              isSender: userId == id,
                              textStyle: TextStyle(
                                  color: userId == id
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16),
                            );
                    },
                  );
                },
              ),
            ),
            Container(
              height: 50,
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(5),
                      child: TextField(
                        controller: _controller,
                        maxLength: 100,
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                          counterText: "",
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(bottom: 8, right: 5, left: 10),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_controller.text.trim().isEmpty) {
                        return;
                      } else {
                        sendMessage(_controller.text);
                      }
                    },
                    child: Container(
                      color: Colors.white.withOpacity(0.001),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendMessage(String message) {
    CollectionReference chat = FirebaseFirestore.instance.collection('chat');

    int userId = user.contains("Smiley") ? 1 : 2;
    chat
        .add({
          'message': message,
          'time': DateTime.now().millisecondsSinceEpoch,
          'userId': userId
        })
        .then((value) => setState(() {
              _controller.clear();
            }))
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to send message. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        });
  }
}
