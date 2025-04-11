import 'package:flutter/material.dart';

class MilkmanPage extends StatelessWidget {
  final List<Map<String, dynamic>> _milkmanList = [
    {"name": "Himesh Desai", "houses": "4 Houses", "rating": "4.5"},
    {"name": "Himesh Desai", "houses": "4 Houses", "rating": "4.5"},
    {"name": "Himesh Desai", "houses": "2 Houses", "rating": "4.5"},
    {"name": "Himesh Desai", "houses": "2 Houses", "rating": "4.5"},
    {"name": "Himesh Desai", "houses": "2 Houses", "rating": "4.5"},
    {"name": "Himesh Desai", "houses": "2 Houses", "rating": "4.5"},
  ];
  MilkmanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.white;
    final Color cardColor = const Color(0xFFF7F7F7);
    final Color textColor = Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        title: const Text(
          "Milkman",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset("assets/images/icons/filter.png", width: 24, height: 24),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Names",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: _milkmanList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: AssetImage("assets/images/profile.png"),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _milkmanList[index]["name"],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _milkmanList[index]["houses"],
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _milkmanList[index]["rating"],
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
                            ),
                            const SizedBox(width: 4),
                            Image.asset("assets/images/icons/star.png", width: 14, height: 14),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
