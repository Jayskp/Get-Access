import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/constants/colors.dart';
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
    {"iconPath": "assets/images/icons/bucket.png", "title": "Cleaning"},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;
    final horizontalPadding =
        screenWidth > 1024 ? 64.0 : (screenWidth > 600 ? 40.0 : 26.0);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            decoration:
                isLargeScreen
                    ? BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          offset: const Offset(0, 0),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    )
                    : null,
            margin:
                isLargeScreen ? const EdgeInsets.symmetric(vertical: 16) : null,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Services",
                          style: _archivoTextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search_rounded, size: 24),
                          tooltip: 'Search',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 24),
                    Text(
                      "Categories",
                      style: _archivoTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isLargeScreen ? 4 : 2,
                        childAspectRatio: isLargeScreen ? 1.2 : 0.85,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: categoryItems.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CategoriesCard(
                            iconPath: categoryItems[index]["iconPath"] ?? "",
                            title: categoryItems[index]["title"] ?? "",
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Trending Services",
                      style: _archivoTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: isLargeScreen ? 4 : 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildTrendingServiceCard(
                          'assets/images/truck.png',
                          'Porter Packers & Movers',
                        ),
                        _buildTrendingServiceCard(
                          'assets/images/locks.png',
                          'Okinava Smart Locks',
                        ),
                        _buildTrendingServiceCard(
                          'assets/images/cabs.png',
                          'Airport Cabs',
                        ),
                        _buildTrendingServiceCard(
                          'assets/images/medical.png',
                          'Instant Medical Help',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingServiceCard(String image, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ServiceCard(image: image, title: title, onTap: () {}),
    );
  }
}
