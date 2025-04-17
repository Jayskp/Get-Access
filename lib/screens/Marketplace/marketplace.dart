import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getaccess/util/constants/colors.dart';
import 'package:getaccess/widgets/social_service_card_marketplace.dart';
import 'package:google_fonts/google_fonts.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({super.key});

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  final List<Map<String, String>> categoryItems = [
    {
      "iconPath": "assets/images/icons/table.furniture.png",
      "title": "Furniture",
      "subtitle": "1.7k+",
    },
    {
      "iconPath": "assets/images/icons/cake.png",
      "title": "Food",
      "subtitle": "1.5k+",
    },
    {
      "iconPath": "assets/images/icons/tv.badge.wifi.png",
      "title": "Electronics",
      "subtitle": "1.2k+",
    },
    {
      "iconPath": "assets/images/icons/badminton.png",
      "title": "Games",
      "subtitle": "856+",
    },
    {
      "iconPath": "assets/images/icons/table.furniture.png",
      "title": "Furniture",
      "subtitle": "1.7k+",
    },
    {
      "iconPath": "assets/images/icons/cake.png",
      "title": "Food",
      "subtitle": "1.5k+",
    },
    {
      "iconPath": "assets/images/icons/tv.badge.wifi.png",
      "title": "Electronics",
      "subtitle": "1.2k+",
    },
    {
      "iconPath": "assets/images/icons/badminton.png",
      "title": "Games",
      "subtitle": "856+",
    },
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

  void _onSearchSubmitted(String query) {
    if (kDebugMode) {
      print('Searching for: $query');
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    "Marketplace",
                    style: _archivoTextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: () {},
                    child: Row(
                      children: [
                        const Icon(Icons.add_circle_outline_outlined, color: Colors.white, size: 17),
                        const SizedBox(width: 4),
                        Text(
                          "New Listing",
                          style: _archivoTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.search, size: 24, color: Colors.grey),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onSubmitted: _onSearchSubmitted,
                        decoration: const InputDecoration(
                          hintText: 'What thing you are looking for...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    if (searchController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        onPressed: () => searchController.clear(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Home Card
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/marketplace_home.png",
                        width: 34,
                        height: 34,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Home",
                              style: _archivoTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Explore more than 1000+ listings",
                              style: _archivoTextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Options Title
              Text(
                "Options",
                style: _archivoTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Category Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  childAspectRatio: 0.86,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categoryItems.length,
                itemBuilder: (context, i) {
                  final item = categoryItems[i];
                  return _buildCategoryCard(
                    iconPath: item["iconPath"]!,
                    title: item["title"]!,
                    subtitle: item["subtitle"]!,
                  );
                },
              ),
              const SizedBox(height:20),

              // Recent Listings Header
              Row(
                children: [
                  Text(
                    "Recent Listings",
                    style: _archivoTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "(100k+ listings)",
                    style: _archivoTextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text(
                          "View all",
                          style: _archivoTextStyle(fontSize: 16, color: AppColors.primaryGreen),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 18, color: AppColors.primaryGreen),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Recent Listings Grid
              GridView.builder(
                shrinkWrap: true,
                physics:NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio:
                  screenWidth > 1024 ? 0.98 : (screenWidth > 600 ? 0.8 : 1),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final items = [
                    {'image': 'assets/images/villas.png', 'title': 'Villas', 'label': 'New'},
                    {'image': 'assets/images/refrigerators.png', 'title': 'Refrigerators', 'label': 'Resale'},
                    {'image': 'assets/images/books.png', 'title': 'Books', 'label': 'New'},
                    {'image': 'assets/images/AC.png', 'title': 'AC', 'label': 'Resale'},
                  ];
                  return SocialServiceCardMarketplace(
                    image: items[index]['image']!,
                    title: items[index]['title']!,
                    label: items[index]['label']!,
                    onTap: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String iconPath,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Image.asset(iconPath, width: 24, height: 24)),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: _archivoTextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: _archivoTextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }
}
