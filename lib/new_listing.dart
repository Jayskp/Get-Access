import 'package:flutter/material.dart';
import 'package:getaccess/util/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class NewListing extends StatefulWidget {
  const NewListing({super.key});

  @override
  State<NewListing> createState() => _NewListingState();
}

class _NewListingState extends State<NewListing> {
  final TextEditingController _textController = TextEditingController();
  String? _selectedCategory;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.restaurant_outlined, 'name': 'Food'},
    {'icon': Icons.miscellaneous_services_outlined, 'name': 'Services'},
    {'icon': Icons.devices_outlined, 'name': 'Electronics & Appliances'},
    {'icon': Icons.motorcycle_outlined, 'name': 'Vehicles'},
    {'icon': Icons.chair_outlined, 'name': 'Furniture'},
    {'icon': Icons.child_care_outlined, 'name': 'Kids Items'},
    {'icon': Icons.more_horiz_outlined, 'name': 'Others'},
  ];

  TextStyle _archivoTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.archivo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }


  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'Choose a category',
                  style: _archivoTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  )
                ),
                const SizedBox(height: 16),
                ..._categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category['name'];
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              category['icon'],
                              size: 24,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              category['name'],
                              style:_archivoTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "New Listing",
          style: _archivoTextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[300], height: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: isSmallScreen ? 20 : 24,
                            backgroundColor: AppColors.primaryYellow,
                            child: Text(
                              'D',
                              style:_archivoTextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                'Dhruv',
                                style: _archivoTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'C-105',
                                style: _archivoTextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Text Area
                      TextField(
                        controller: _textController,
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: 'Write something about it.........',
                          hintStyle: _archivoTextStyle(color: Colors.grey.shade500),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Category Button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextButton(
                          onPressed: _showCategoryDialog,
                          child: Text(
                            _selectedCategory ?? 'Choose a Category',
                            style: _archivoTextStyle(
                                color: Colors.grey, fontSize: 16
                            ),
                          ),
                        ),
                      ),
                      // Add extra padding at the bottom to ensure content is visible when scrolled
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            // Post Button fixed at bottom, outside of scrollable area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // Handle post
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:  Text(
                  'Post',
                  style: _archivoTextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset:
          false, // Prevents the screen from resizing when keyboard appears
    );
  }
}
