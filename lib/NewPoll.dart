import 'package:flutter/material.dart';

class NewPollPage extends StatefulWidget {
  const NewPollPage({super.key});

  @override
  State<NewPollPage> createState() => _NewPollPageState();
}

class _NewPollPageState extends State<NewPollPage> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<String> _residents = ["Residents", "Owners", "Tenants"];
  String _selectedResident = "Residents";

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color dividerColor = const Color(0xFFE0E0E0);
    final Color lightGreyColor = const Color(0xFFF7F7F7);
    final Color textGreyColor = Colors.grey.shade700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 64,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "New Poll",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info_outline, color: Colors.green, size: 16),
              label: const Text(
                "Guidelines",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.green),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Divider(color: dividerColor, height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: const AssetImage("assets/images/icons/Group 1.png"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Dhruv", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(height: 4),
                        Text("C Block,104", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: lightGreyColor, borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedResident,
                        items: _residents.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 12, color: Colors.black)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedResident = val);
                        },
                        icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: lightGreyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _questionController,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        hintText: "Write your Question here!!!!",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: lightGreyColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: List.generate(_optionControllers.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: TextField(
                            controller: _optionControllers[index],
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(12),
                              hintText: "Option ${index + 1}",
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: _addOption,
                        icon: const Icon(Icons.add, color: Colors.black),
                        label: const Text(
                          "Add Option",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text("Post", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
