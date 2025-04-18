import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/social_post.dart';
import 'providers/social_post_provider.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});
  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final List<String> _residents = ["Residents", "Owners", "Tenants"];
  String _selectedResident = "Residents";
  final TextEditingController _propertyController = TextEditingController(
    text: "C-104 Radhe Kirtan",
  );
  final TextEditingController _dateController = TextEditingController(
    text: "Select Date",
  );
  final TextEditingController _priceController = TextEditingController(
    text: "Price range",
  );
  final TextEditingController _contentController = TextEditingController();
  bool _isSellSelected = true;

  @override
  void dispose() {
    _contentController.dispose();
    _propertyController.dispose();
    _dateController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFFFFFFFF);
    final Color containerColor = const Color(0xFFF7F7F7);
    final Color primaryColor = Colors.green;
    final Color textColor = Colors.black;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Edit Listing Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedResident,
                items:
                    _residents.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                          style: TextStyle(fontSize: 14, color: textColor),
                        ),
                      );
                    }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedResident = val);
                },
                icon: Icon(Icons.keyboard_arrow_down, color: textColor),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  "Select the Property",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _propertyController.text,
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: containerColor,
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/icons/add-circle.png",
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Add Flat/Home/Villa",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Select what to do",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isSellSelected = true),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color:
                                _isSellSelected ? primaryColor : containerColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Sell",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _isSellSelected ? Colors.white : textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isSellSelected = false),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color:
                                !_isSellSelected
                                    ? primaryColor
                                    : containerColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Rent Out",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  !_isSellSelected ? Colors.white : textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Available From",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          _dateController.text,
                          style: TextStyle(fontSize: 14, color: textColor),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Price",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _priceController,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _contentController,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    maxLines: 4,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      hintText: "Describe your property",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => _createPost(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createPost(BuildContext context) {
    if (_contentController.text.isEmpty) {
      _contentController.text =
          "Available for ${_isSellSelected ? 'Sell' : 'Rent'} at ${_propertyController.text}";
    }

    final content =
        _contentController.text +
        "\n\nPrice: ${_priceController.text}" +
        "\nAvailable From: ${_dateController.text}";

    final post = SocialPost.fromPost(
      authorName: "You",
      authorBlock: _propertyController.text,
      content: content,
    );

    Provider.of<SocialPostProvider>(context, listen: false).addPost(post);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your post has been created!'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }
}
