import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  final List<Map<String, dynamic>> notifications = [
    {
      'username': 'Nilesh',
      'message': '...hi how are .....what\'s up',
      'time': '5 mins ago',
      'isRead': true,
    },
    {
      'username': 'Nilesh',
      'message': '...hi how are .....what\'s up',
      'time': '5 mins ago',
      'isRead': false,
    },
    {
      'username': 'Nilesh',
      'message': '...hi how are .....what\'s up',
      'time': '5 mins ago',
      'isRead': true,
    },
    {
      'username': 'Nilesh',
      'message': '...hi how are .....what\'s up',
      'time': '5 mins ago',
      'isRead': false,
    },
    {
      'username': 'Nilesh',
      'message': '...hi how are .....what\'s up',
      'time': '5 mins ago',
      'isRead': true,
    },
    {
      'username': 'Nilesh',
      'message': '...hi how are .....what\'s up',
      'time': '5 mins ago',
      'isRead': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final current = notifications[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundImage: const AssetImage('assets/images/avatar1.png'),
            ),
            title: Text(
              '${current['username']}  ${current['message']}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              current['time'],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: current['isRead']
                    ? Colors.grey[300]
                    : const Color(0xFFFFC107),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                current['isRead'] ? 'Read' : 'Unread',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: current['isRead'] ? Colors.black54 : Colors.white,
                ),
              ),
            ),
            onTap: () {
              setState(() {
                notifications[index]['isRead'] = !notifications[index]['isRead'];
              });
            },
          );
        },
      ),
    );
  }
}
