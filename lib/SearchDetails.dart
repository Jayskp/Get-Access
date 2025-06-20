import 'package:flutter/material.dart';
import 'package:getaccess/Milkman.dart';
import 'package:getaccess/daily_help.dart';

class SearchDetailsPage extends StatefulWidget {
  const SearchDetailsPage({super.key});

  @override
  State<SearchDetailsPage> createState() => _SearchDetailsPageState();
}

class _SearchDetailsPageState extends State<SearchDetailsPage> {
  final List<Map<String, String>> _popularSearches = [
    {"icon": "assets/images/icons/daily_help.png", "title": "Daily Help"},
    {"icon": "assets/images/icons/society_dues.png", "title": "Society Dues"},
    {
      "icon": "assets/images/icons/visitors_approval.png",
      "title": "Visitors Approval",
    },
    {"icon": "assets/images/icons/carpenters.png", "title": "Carpenters"},
    {"icon": "assets/images/icons/plumber.png", "title": "Plumber"},
    {"icon": "assets/images/icons/plumber.png", "title": "Electrician"},
    {"icon": "assets/images/icons/milkman.png", "title": "Milkman"},
    {"icon": "assets/images/icons/carpenters.png", "title": "Carpenters"},
  ];

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.white;
    final Color greyLineColor = const Color(0xFFEEEEEE);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        centerTitle: false,
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Image.asset(
                "assets/images/icons/search.png",
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "What are you looking for?",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Popular searches",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _popularSearches.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            final title = _popularSearches[index]["title"];
                            if (title == "Daily Help") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DailyHelp(),
                                ),
                              );
                            } else if (title == "Milkman") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MilkmanPage(),
                                ),
                              );
                            } else {
                              // You can leave this empty or show a snackbar if you want
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '$title page is not available yet.',
                                  ),
                                ),
                              );
                            }
                          },

                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Image.asset(
                                  _popularSearches[index]["icon"]!,
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  _popularSearches[index]["title"]!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(height: 1, color: greyLineColor),
                      const SizedBox(height: 8),
                    ],
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
