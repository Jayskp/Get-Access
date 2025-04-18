import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyHelp extends StatefulWidget {
  const DailyHelp({super.key});

  @override
  State<DailyHelp> createState() => _DailyHelpState();
}

class _DailyHelpState extends State<DailyHelp> {
  final TextEditingController _searchController = TextEditingController();

  // Helper data
  final List<Map<String, dynamic>> _cooksList = [
    {'name': 'Himesh Desai', 'houses': 4, 'rating': 4.8},
    {'name': 'Himesh Desai', 'houses': 4, 'rating': 4.7},
  ];

  final List<Map<String, dynamic>> _maidsList = [
    {'name': 'Himesh Desai', 'houses': 4, 'rating': 4.8},
    {'name': 'Himesh Desai', 'houses': 4, 'rating': 4.9},
  ];

  final List<Map<String, dynamic>> _allHelpers = [
    {'title': 'Driver', 'icon': Icons.drive_eta_outlined},
    {'title': 'Milkman', 'icon': Icons.breakfast_dining_outlined},
    {'title': 'Nanny', 'icon': Icons.child_care_outlined},
    {'title': 'Gym Trainner', 'icon': Icons.fitness_center_outlined},
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

  // Helper card widget
  Widget _buildHelperCard(Map<String, dynamic> helper, double screenWidth) {
    // Make card width responsive
    final cardWidth = screenWidth < 360 ? screenWidth * 0.42 : 160.0;
    final avatarSize = screenWidth < 360 ? 20.0 : 24.0;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: avatarSize,
              backgroundColor: Colors.grey.shade300,
              child: Icon(
                Icons.person,
                color: Colors.grey.shade600,
                size: avatarSize * 0.8,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    helper['name'],
                    style: _archivoTextStyle(
                      fontSize: screenWidth < 360 ? 12 : 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${helper['houses']} Houses',
                    style: _archivoTextStyle(
                      fontSize: screenWidth < 360 ? 10 : 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${helper['rating']}',
                      style: _archivoTextStyle(
                        fontSize: screenWidth < 360 ? 8 : 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper category row
  Widget _buildCategoryRow(
    String title,
    IconData icon,
    int count,
    bool showArrow,
    double screenWidth,
  ) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth < 360 ? 12.0 : 16.0,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: screenWidth < 360 ? 20 : 24,
              color: Colors.black87,
            ),
            SizedBox(width: screenWidth < 360 ? 12 : 16),
            Expanded(
              child: Text(
                title,
                style: _archivoTextStyle(
                  fontSize: screenWidth < 360 ? 14 : 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (count > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '($count)',
                  style: _archivoTextStyle(
                    fontSize: screenWidth < 360 ? 12 : 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: screenWidth < 360 ? 14 : 16,
                color: Colors.black54,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Daily Help',
          style: _archivoTextStyle(
            fontSize: screenWidth < 360 ? 16 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by Name',
                        hintStyle: _archivoTextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.black87),
                    onPressed: () {},
                    tooltip: 'Filter',
                    padding: EdgeInsets.all(screenWidth < 360 ? 8 : 12),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              children: [
                // Cooks section
                _buildCategoryRow(
                  'Cooks in our society',
                  Icons.restaurant_outlined,
                  25,
                  true,
                  screenWidth,
                ),

                // Cooks list
                SizedBox(
                  height: screenWidth < 360 ? 80 : 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _cooksList.length,
                    itemBuilder: (context, index) {
                      return _buildHelperCard(_cooksList[index], screenWidth);
                    },
                  ),
                ),

                SizedBox(height: screenWidth < 360 ? 8 : 12),

                // Maids section
                _buildCategoryRow(
                  'Maids in our society',
                  Icons.cleaning_services_outlined,
                  15,
                  true,
                  screenWidth,
                ),

                // Maids list
                SizedBox(
                  height: screenWidth < 360 ? 80 : 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _maidsList.length,
                    itemBuilder: (context, index) {
                      return _buildHelperCard(_maidsList[index], screenWidth);
                    },
                  ),
                ),

                SizedBox(height: screenWidth < 360 ? 16 : 24),

                // All Daily Help section
                Text(
                  'All Daily Help',
                  style: _archivoTextStyle(
                    fontSize: screenWidth < 360 ? 16 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // All helpers list
                ...List.generate(
                  _allHelpers.length,
                  (index) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCategoryRow(
                        _allHelpers[index]['title'],
                        _allHelpers[index]['icon'],
                        0,
                        false,
                        screenWidth,
                      ),
                      if (index < _allHelpers.length - 1)
                        const Divider(height: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
