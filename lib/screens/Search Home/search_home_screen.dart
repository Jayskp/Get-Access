import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/constants/colors.dart';
import '../../widgets/property_card.dart';

class SearchHomeScreen extends StatefulWidget {
  const SearchHomeScreen({Key? key}) : super(key: key);

  @override
  State<SearchHomeScreen> createState() => _SearchHomeScreenState();
}

class _SearchHomeScreenState extends State<SearchHomeScreen> {
  // Toggle state for Rent vs Buy
  bool _isRentSelected = true;

  // Example lists for the dropdowns
  final List<String> _locations = [
    'Location 1',
    'Location 2',
    'Location 3',
  ];
  final List<String> _priceRanges = [
    '\$500 - \$1000',
    '\$1000 - \$1500',
    '\$1500 - \$2000',
  ];

  // Currently selected items
  String _selectedLocation = 'Location 1';
  String _selectedPriceRange = '\$500 - \$1000';

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 32.0 : 26.0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header Row
                  Row(
                    children: [
                      Text(
                        "Homes",
                        style: _archivoTextStyle(
                          fontSize: screenWidth > 600 ? 24 : 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          // Add your onPressed action here
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_circle_outline_outlined,
                              color: Colors.white,
                              size: 17,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "Add Property",
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
                  Divider(thickness: 1, color: AppColors.lightGrey),
                  const SizedBox(height: 8),

                  /// The updated responsive search container
                  _buildSearchContainer(screenWidth),
                  const SizedBox(height: 16),

                  /// Recent Properties Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Text(
                            "View Recent Properties",
                            style: _archivoTextStyle(color: Colors.grey),
                          ),
                          const SizedBox(width: 20),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                right: 4,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.home_outlined, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Property Cards
                  _buildPropertyCardsGrid(screenWidth),
                  const SizedBox(height: 16),

                  /// Testimonials Section
                  Text(
                    "Testimonials",
                    style: _archivoTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Testimonials Container
                  _buildTestimonialsContainer(screenWidth),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchContainer(double screenWidth) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.lightGrey,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          /// Rent/Buy toggle
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  /// Rent
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isRentSelected = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isRentSelected ? AppColors.primaryGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        child: Text(
                          "Rent",
                          style: _archivoTextStyle(
                            fontSize: 18,
                            color: _isRentSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Buy
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isRentSelected = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: !_isRentSelected ? AppColors.primaryGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        child: Text(
                          "Buy",
                          style: _archivoTextStyle(
                            fontSize: 18,
                            color: !_isRentSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "What locations......",
                hintStyle: _archivoTextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Location & Price Range Row - Responsive
          screenWidth > 600
              ? Row(
            children: [
              Expanded(child: _buildLocationDropdown()),
              const SizedBox(width: 12),
              Expanded(child: _buildPriceRangeDropdown()),
            ],
          )
              : Column(
            children: [
              _buildLocationDropdown(),
              const SizedBox(height: 12),
              _buildPriceRangeDropdown(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLocation,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: _archivoTextStyle(),
          items: _locations.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: _archivoTextStyle(),
              ),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              _selectedLocation = val!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPriceRangeDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPriceRange,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: _archivoTextStyle(),
          items: _priceRanges.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: _archivoTextStyle(),
              ),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              _selectedPriceRange = val!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPropertyCardsGrid(double screenWidth) {
    // For wider screens, arrange property cards in a grid
    if (screenWidth > 900) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          propertyCard(
            imageUrl: "assets/images/image.png",
            title: "Sahaj Flats",
            location: "Sola, Ahmedabad",
            price: "50,00,00",
            bhk: "3 BHK",
          ),
          propertyCard(
            imageUrl: "assets/images/image.png",
            title: "Sahaj Flats",
            location: "Sola, Ahmedabad",
            price: "50,00,00",
            bhk: "3 BHK",
          ),
        ],
      );
    } else {
      // For smaller screens, keep the original vertical layout
      return Column(
        children: [
          propertyCard(
            imageUrl: "assets/images/image.png",
            title: "Sahaj Flats",
            location: "Sola, Ahmedabad",
            price: "50,00,00",
            bhk: "3 BHK",
          ),
          const SizedBox(height: 10),
          propertyCard(
            imageUrl: "assets/images/image.png",
            title: "Sahaj Flats",
            location: "Sola, Ahmedabad",
            price: "50,00,00",
            bhk: "3 BHK",
          ),
        ],
      );
    }
  }

  Widget _buildTestimonialsContainer(double screenWidth) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(25)
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "There will be a scheduled power outage on Wednesday from 2 PM to 5 PM for maintenance. Sorry for the inconvenience",
              style: _archivoTextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),

            // Responsive testimonial profiles
            screenWidth > 700
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildTestimonialProfile()),
                const SizedBox(width: 20),
                Expanded(child: _buildTestimonialProfile()),
              ],
            )
                : Column(
              children: [
                _buildTestimonialProfile(),
                const SizedBox(height: 10),
                _buildTestimonialProfile(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonialProfile() {
    return Row(
      children: [
        Image(image: const AssetImage("assets/images/icons/image.png")),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dhruv Patel", style: _archivoTextStyle()),
            const SizedBox(height: 5),
            Text(
              "Block A-102",
              style: _archivoTextStyle(
                  fontSize: 12,
                  color: Colors.grey
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Ahmedabad",
              style: _archivoTextStyle(
                  fontSize: 10,
                  color: Colors.grey
              ),
            )
          ],
        )
      ],
    );
  }
}