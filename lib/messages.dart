import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final List<Map<String, dynamic>> chatMessages = [
    {
      'message': 'Lorem Ipsum is simply dummi',
      'time': '02:30 PM',
      'isSent': false,
    },
    {
      'message': 'Lorem Ipsum is simply dummi',
      'time': '02:30 PM',
      'isSent': true,
    },
    {
      'message': 'Lorem Ipsum is simply dummi',
      'time': '02:30 PM',
      'isSent': false,
    },
    {
      'message': 'Lorem Ipsum is simply dummi',
      'time': '02:30 PM',
      'isSent': true,
    },
    {
      'message': 'Lorem Ipsum is simply dummi',
      'time': '02:30 PM',
      'isSent': false,
    },
    {
      'message': 'Lorem Ipsum is simply dummi',
      'time': '02:30 PM',
      'isSent': true,
    },
  ];

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      chatMessages.insert(0, {
        'message': text.trim(),
        'time': '02:30 PM',
        'isSent': true,
      });
    });
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(Map<String, dynamic> data) {
    final bubbleColor = data['isSent'] ? Color.fromRGBO(49, 175, 100, 1) : Colors.white;
    final align = data['isSent'] ? Alignment.centerRight : Alignment.centerLeft;
    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              data['message'],
              style: TextStyle(fontSize: 14, color: data['isSent'] ? Colors.white: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              data['time'],
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/images/icons/emoji.png',
              width: 24,
              height: 24,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              onSubmitted: _sendMessage,
              decoration: const InputDecoration(
                hintText: 'Type a message',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/images/icons/attachment.png',
              width: 24,
              height: 24,
            ),
          ),
          Container(
            height: 24,
            width: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF8696A0),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/icons/money.png',
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/images/icons/camera.png',
              width: 24,
              height: 24,
            ),
          ),
          Container(
            width: 48,
            height: 48,
            margin: const EdgeInsets.only(left: 4),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(49, 175, 100, 1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/images/icons/microphone.png',
                width: 24,
                height: 24,
              ),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(49, 175, 100, 1),
        leadingWidth: 80,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: const AssetImage('assets/images/avatar1.png'),
              backgroundColor: Colors.grey,
            ),
          ],
        ),
        title: const Text(
          'Swati Patel',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/images/icons/phone2.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/images/icons/videocall.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/images/icons/menu.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(chatMessages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }
}
