import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:provider/provider.dart';
import 'models/social_post.dart';
import 'providers/social_post_provider.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({super.key});

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController(
    text: "05/07/25",
  );
  final TextEditingController _timeController = TextEditingController(
    text: "10 : 00 AM",
  );
  final TextEditingController _venueController = TextEditingController(
    text: "Club house",
  );
  bool _showEmojiPicker = false;
  File? _pickedImage;
  File? _pickedFile;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
  final List<String> _residents = ["Residents", "Owners", "Tenants"];
  String _selectedResident = "Residents";

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
          "New Event",
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
          if (_showEmojiPicker) setState(() => _showEmojiPicker = false);
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
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  hintText: "Write Description",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: lightGreyColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (_pickedImage != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _pickedImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              if (_pickedFile != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "File: ${_pickedFile!.path.split('/').last}",
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _iconButton(
                        icon: Icons.insert_drive_file_outlined,
                        onTap: _pickFile,
                        tooltip: "Pick a file",
                      ),
                      const SizedBox(width: 16),
                      _iconButton(
                        icon: Icons.image_outlined,
                        onTap: _pickImage,
                        tooltip: "Pick an image",
                      ),
                      const SizedBox(width: 16),
                      _iconButton(
                        icon: Icons.emoji_emotions_outlined,
                        onTap:
                            () => setState(
                              () => _showEmojiPicker = !_showEmojiPicker,
                            ),
                        tooltip: "Pick an emoji",
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _createEvent(context),
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
              if (_showEmojiPicker)
                Container(
                  height: 300,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      _descriptionController.text += emoji.emoji;
                    },
                    config: Config(
                      height: 300,
                      checkPlatformCompatibility: true,
                      locale: const Locale('en'),
                      emojiTextStyle: const TextStyle(fontSize: 24),
                      customBackspaceIcon: const Icon(
                        Icons.backspace,
                        color: Colors.black,
                      ),
                      customSearchIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      viewOrderConfig: const ViewOrderConfig(),
                      emojiViewConfig: const EmojiViewConfig(),
                      skinToneConfig: const SkinToneConfig(),
                      categoryViewConfig: const CategoryViewConfig(),
                      bottomActionBarConfig: const BottomActionBarConfig(),
                      searchViewConfig: const SearchViewConfig(),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Add Date & Time",
                  style: TextStyle(
                    fontSize: 14,
                    color: textGreyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _dateTimeField(
                      controller: _dateController,
                      icon: Icons.calendar_month_outlined,
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _dateTimeField(
                      controller: _timeController,
                      icon: Icons.access_time_outlined,
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Add Venue",
                  style: TextStyle(
                    fontSize: 14,
                    color: textGreyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _venueController,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Club house",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: lightGreyColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF7F7F7),
        ),
        child: Icon(icon, size: 20, color: Colors.black54),
      ),
    );
  }

  Widget _dateTimeField({
    required TextEditingController controller,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              controller.text,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const Spacer(),
            Icon(icon, size: 20, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = File(result.files.first.path!);
      });
    }
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: DateTime(today.year + 5),
    );
    if (newDate != null) {
      setState(() {
        selectedDate = newDate;
        _dateController.text =
            "${selectedDate.month.toString().padLeft(2, '0')}/"
            "${selectedDate.day.toString().padLeft(2, '0')}/"
            "${selectedDate.year}";
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (newTime != null) {
      setState(() {
        selectedTime = newTime;
        final hour =
            selectedTime.hourOfPeriod == 0 ? 12 : selectedTime.hourOfPeriod;
        final ampm = selectedTime.period == DayPeriod.am ? "AM" : "PM";
        _timeController.text =
            "${hour.toString().padLeft(2, '0')} : ${selectedTime.minute.toString().padLeft(2, '0')} $ampm";
      });
    }
  }

  void _createEvent(BuildContext context) {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a description for your event'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    List<String>? imageUrls;
    if (_pickedImage != null) {
      // In a real app, we would upload the image and get the URL
      // For this example, we'll just store the path
      imageUrls = [_pickedImage!.path];
    }

    final event = SocialPost.fromEvent(
      authorName: "Dhruv",
      authorBlock: "C Block,104",
      description: _descriptionController.text,
      eventDate: selectedDate,
      eventTime: _timeController.text,
      eventVenue: _venueController.text,
      imageUrls: imageUrls,
    );

    Provider.of<SocialPostProvider>(context, listen: false).addPost(event);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your event has been created!'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }
}
