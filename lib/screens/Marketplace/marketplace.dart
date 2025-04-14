import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getaccess/util/constants/colors.dart';
import 'package:getaccess/widgets/Social_service_card_marketplace.dart';
import 'package:getaccess/widgets/options_card.dart';
import 'package:getaccess/widgets/quick_access_card.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/social_services_card.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController searchController = TextEditingController();
    final double horizontalPadding = screenWidth > 600 ? 40 : 20;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Row(
                  children: [
                    Text(
                      "Marketplace",
                      style: _archivoTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline_outlined,
                            color: Colors.white,
                            size: 17,
                          ),
                          SizedBox(width: 3),
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

                const SizedBox(height: 8),
                Divider(color: Colors.grey),
                const SizedBox(height: 8),

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
                          decoration: InputDecoration(
                            hintText: 'What thing you are looking for...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      if (searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[600]),
                          onPressed: () {
                            searchController.clear();
                          },
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(17),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/marketplace_home.png",
                                height: 34,
                                width: 34,
                              ),
                              const SizedBox(
                                width: 10,
                              ), // Adds spacing between image and text
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Home",
                                    style: _archivoTextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "Explore more than 1000+ listings",
                                    style: _archivoTextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Options",
                  style: _archivoTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: categoryItems.length,
                  itemBuilder: (context, index) {
                    return buildCategoryCard(
                      iconPath: categoryItems[index]["iconPath"] ?? "",
                      title: categoryItems[index]["title"] ?? "",
                      subtitle: categoryItems[index]["subtitle"] ?? "",
                    );
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      "Recent Listings",
                      style: _archivoTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 3),
                    Text(
                      "(100k+ listings)",
                      style: _archivoTextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            "View all",
                            style: _archivoTextStyle(
                              fontSize: 16,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primaryGreen,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    SocialServiceCardMarketplace(
                      image: 'assets/images/villas.png',
                      title: 'Villas',
                      onTap: () {},
                      label: 'New',
                    ),
                    SocialServiceCardMarketplace(
                      image: 'assets/images/refrigerators.png',
                      title: 'Referigerators',
                      onTap: () {},
                      label: 'Resale',
                    ),
                    SocialServiceCardMarketplace(
                      image: 'assets/images/books.png',
                      title: 'Books',
                      onTap: () {},
                      label: 'New',
                    ),
                    SocialServiceCardMarketplace(
                      image: 'assets/images/AC.png',
                      title: 'AC',
                      onTap: () {},
                      label: 'Resale',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
