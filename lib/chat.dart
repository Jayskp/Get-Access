import 'package:flutter/material.dart';
import 'package:getaccess/messages.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<Map<String, dynamic>> chatData = [
    {
      'username': 'Rajesh Block B-104',
      'avatar': 'assets/images/avatar1.png',
      'message': 'Hi Bro today Gym....?',
      'time': '11:25 Am'
    },
    {
      'username': 'Rajesh Block B-104',
      'avatar': 'assets/images/avatar2.png',
      'message': 'Hi Bro today Gym....?',
      'time': '11:25 Am'
    },
    {
      'username': 'Rajesh Block B-104',
      'avatar': 'assets/images/avatar1.png',
      'message': 'Hi Bro today Gym....?',
      'time': '11:25 Am'
    },
    {
      'username': 'Rajesh Block B-104',
      'avatar': 'assets/images/avatar2.png',
      'message': 'Hi Bro today Gym....?',
      'time': '11:25 Am'
    },
    {
      'username': 'Rajesh Block B-104',
      'avatar': 'assets/images/avatar1.png',
      'message': 'Hi Bro today Gym....?',
      'time': '11:25 Am'
    },
    {
      'username': 'Rajesh Block B-104',
      'avatar': 'assets/images/avatar2.png',
      'message': 'Hi Bro today Gym....?',
      'time': '11:25 Am'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: chatData.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Messages()));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(chatData[index]['avatar']),
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  chatData[index]['username'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              subtitle: Text(
                chatData[index]['message'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              trailing: Text(
                chatData[index]['time'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: Image.asset('assets/images/icons/Chat2.png'),
      ),
    );
  }
}
