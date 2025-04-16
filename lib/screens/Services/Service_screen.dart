import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/categories_card.dart';
import '../../widgets/social_services_card.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
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

  final List<Map<String, String>> categoryItems = [
    {
      "iconPath": "assets/images/icons/Services.png",
      "title": "Services by Urab",
    },
    {
      "iconPath": "assets/images/icons/car.side.arrowtriangle.down.png",
      "title": "Airport Cabs",
    },
    {
      "iconPath": "assets/images/icons/tabler_truck-delivery.png",
      "title": "Movers & Packers",
    },
    {
      "iconPath": "assets/images/icons/bucket.png",
      "title": "Cleaning",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen width to make responsive decisions
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate padding based on screen width
    final horizontalPadding = screenWidth > 600 ? screenWidth * 0.08 : 26.0;

    // Calculate different grid counts based on screen width
    int categoryCount = 4; // Default for mobile
    double categoryChildAspectRatio = 0.72;

    if (screenWidth > 600 && screenWidth < 960) {
      // For tablets
      categoryCount = 6;
      categoryChildAspectRatio = 0.8;
    } else if (screenWidth >= 960) {
      // For desktops and larger screens
      categoryCount = 8;
      categoryChildAspectRatio = 0.9;
    }

    // Calculate grid counts for services section
    int servicesCount = 2; // Default for mobile
    double servicesChildAspectRatio = 1.0;

    if (screenWidth > 600 && screenWidth < 960) {
      // For tablets
      servicesCount = 3;
    } else if (screenWidth >= 960) {
      // For desktops and larger screens
      servicesCount = 4;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar - Always maintain original look but adapt to wider screens
                Row(
                  children: [
                    Text(
                      "Services",
                      style: _archivoTextStyle(
                        fontSize: screenWidth > 600 ? 24 : 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search_rounded, size: screenWidth > 600 ? 28 : 24),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Divider(color: Colors.grey),
                const SizedBox(height: 8),

                // Categories Section
                Text(
                  "Categories",
                  style: _archivoTextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth > 600 ? 22 : 18,
                      color: Colors.black
                  ),
                ),
                SizedBox(height: 16),

                // Responsive GridView for Categories
                LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth > 600 ?
                          (constraints.maxWidth > 960 ? 8 : 6) : 4,
                          childAspectRatio: categoryChildAspectRatio,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: categoryItems.length,
                        itemBuilder: (context, index) {
                          return CategoriesCard(
                            iconPath: categoryItems[index]["iconPath"] ?? "",
                            title: categoryItems[index]["title"] ?? "",
                          );
                        },
                      );
                    }
                ),

                SizedBox(height: 16),

                // Trending Services Section
                Text(
                  "Trending Services",
                  style: _archivoTextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth > 600 ? 22 : 18,
                      color: Colors.black
                  ),
                ),
                SizedBox(height: 16),

                // Responsive GridView for Services
                LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 2; // Default for mobile

                      if (constraints.maxWidth > 600) {
                        crossAxisCount = constraints.maxWidth > 960 ? 4 : 3;
                      }

                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          ServiceCard(
                            image: 'assets/images/truck.png',
                            title: 'Porter Packers & Movers',
                            onTap: () {},
                          ),
                          ServiceCard(
                            image: 'assets/images/locks.png',
                            title: 'Okinava Smart Locks',
                            onTap: () {},
                          ),
                          ServiceCard(
                            image: 'assets/images/cabs.png',
                            title: 'Airport Cabs',
                            onTap: () {},
                          ),
                          ServiceCard(
                            image: 'assets/images/medical.png',
                            title: 'Instant Medical Help',
                            onTap: () {},
                          ),
                        ],
                      );
                    }
                ),

                // Add bottom padding for better UX
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}