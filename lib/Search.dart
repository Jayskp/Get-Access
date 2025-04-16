import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<String> _blocks = ["Block", "A-Block", "B-Block", "C-Block"];
  final List<String> _floors = ["Floor", "1st Floor", "2nd Floor", "3rd Floor"];
  String _selectedBlock = "Block";
  String _selectedFloor = "Floor";

  final List<Map<String, dynamic>> _data = [
    {
      "floorTitle": "1st Floor",
      "people": [
        {
          "avatar": "assets/images/avatar.png",
          "name": "Dhruv Patel",
          "flat": "A104",
        },
      ],
    },
    {
      "floorTitle": "2nd Floor",
      "people": [
        {
          "avatar": "assets/images/avatar.png",
          "name": "Sonal Desai",
          "flat": "A105",
        },
        {
          "avatar": "assets/images/avatar.png",
          "name": "Rahul Sharma",
          "flat": "A106",
        },
      ],
    },
    {
      "floorTitle": "3rd Floor",
      "people": [
        {
          "avatar": "assets/images/avatar.png",
          "name": "Priya Singh",
          "flat": "B101",
        },
        {
          "avatar": "assets/images/avatar.png",
          "name": "Karan Kumar",
          "flat": "B102",
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.white;
    final Color textColor = Colors.black;
    final Color cardColor = const Color(0xFFF2F2F2);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Search Residents",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedBlock,
                        items:
                            _blocks.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedBlock = val);
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFloor,
                        items:
                            _floors.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedFloor = val);
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _data[index]["floorTitle"],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: List.generate(_data[index]["people"].length, (i) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage(
                          _data[index]["people"][i]["avatar"],
                        ),
                      ),
                      title: Text(
                        _data[index]["people"][i]["name"],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        _data[index]["people"][i]["flat"],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 64,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Image.asset(
                                "assets/images/icons/call.png",
                                width: 24,
                                height: 24,
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Image.asset(
                                "assets/images/icons/chat.png",
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
