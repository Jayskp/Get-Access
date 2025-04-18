import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/social_post.dart';
import 'providers/social_post_provider.dart';

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
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

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

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.info_outline,
                color: Colors.green,
                size: 16,
              ),
              label: const Text(
                "Guidelines",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
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
                    backgroundImage: const AssetImage(
                      "assets/images/icons/Group 1.png",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Dhruv",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "C Block,104",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: lightGreyColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedResident,
                        items:
                            _residents.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedResident = val);
                          }
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
                      children: List.generate(_optionControllers.length, (
                        index,
                      ) {
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: lightGreyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Poll ends on: ${_endDate.day}/${_endDate.month}/${_endDate.year}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _selectEndDate,
                      child: const Text("Change"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => _createPoll(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAFE9C6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Post",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(width: 8),
                        Image.asset(
                          'assets/images/icons/post.png',
                          width: 18,
                          height: 18,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
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

  void _createPoll(BuildContext context) {
    if (_questionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a question for your poll'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final validOptions =
        _optionControllers
            .where((controller) => controller.text.isNotEmpty)
            .map((controller) => PollOption(text: controller.text))
            .toList();

    if (validOptions.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least two options for your poll'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final poll = SocialPost.fromPoll(
      authorName: "Dhruv",
      authorBlock: "C Block,104",
      question: _questionController.text,
      options: validOptions,
      endDate: _endDate,
    );

    Provider.of<SocialPostProvider>(context, listen: false).addPost(poll);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your poll has been created!'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }
}
