import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getaccess/screens/Community/community_screen.dart';
import 'package:getaccess/screens/Marketplace/marketplace.dart';
import 'package:getaccess/screens/Search%20Home/search_home_screen.dart';
import 'package:getaccess/screens/Services/Service_screen.dart';
import 'package:getaccess/screens/Social%20screen/social_screen.dart';

class BottomNavBarDemo extends StatefulWidget {
  final bool isAdmin;

  const BottomNavBarDemo({super.key, this.isAdmin = false});

  @override
  State<BottomNavBarDemo> createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<BottomNavBarDemo> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // Initialize screens with admin status
    _screens = [
      SocialScreen(isAdmin: widget.isAdmin),
      CommunityScreen(),
      SearchHomeScreen(),
      Marketplace(),
      ServiceScreen(),
    ];
  }

  // Theme colors
  // static const Color primaryColor = Color(0xFF004D40);
  // static const Color secondaryColor = Color(0xFF00796B);
  // static const Color accentColor = Color(0xFF26A69A);
  static const Color grayText = Color(0xFF4A4A4A);

  TextStyle _archivoTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.archivo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 0.2,
    );
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Exit App',
              style: _archivoTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to exit?',
              style: _archivoTextStyle(fontSize: 16, color: grayText),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: _archivoTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: grayText,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  SystemNavigator.pop(); // Close the app
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Exit',
                  style: _archivoTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 600;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body:
            isWeb
                ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _currentIndex,
                      onDestinationSelected: (index) {
                        setState(() => _currentIndex = index);
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: [
                        NavigationRailDestination(
                          icon: _buildNavIcon(
                            'assets/images/icons/Social.png',
                            0,
                          ),
                          selectedIcon: _buildNavIcon(
                            'assets/images/icons/Social.png',
                            0,
                          ),
                          label: _buildNavLabel('Social', 0),
                        ),
                        NavigationRailDestination(
                          icon: _buildNavIcon(
                            'assets/images/icons/Community.png',
                            1,
                          ),
                          selectedIcon: _buildNavIcon(
                            'assets/images/icons/Community.png',
                            1,
                          ),
                          label: _buildNavLabel('Community', 1),
                        ),
                        NavigationRailDestination(
                          icon: _buildNavIcon(
                            'assets/images/icons/Homes.png',
                            2,
                          ),
                          selectedIcon: _buildNavIcon(
                            'assets/images/icons/Homes.png',
                            2,
                          ),
                          label: _buildNavLabel('Homes', 2),
                        ),
                        NavigationRailDestination(
                          icon: _buildNavIcon(
                            'assets/images/icons/Marketplace.png',
                            3,
                          ),
                          selectedIcon: _buildNavIcon(
                            'assets/images/icons/Marketplace.png',
                            3,
                          ),
                          label: _buildNavLabel('Marketplace', 3),
                        ),
                        NavigationRailDestination(
                          icon: _buildNavIcon(
                            'assets/images/icons/Services.png',
                            4,
                          ),
                          selectedIcon: _buildNavIcon(
                            'assets/images/icons/Services.png',
                            4,
                          ),
                          label: _buildNavLabel('Services', 4),
                        ),
                      ],
                    ),
                    Expanded(child: _screens[_currentIndex]),
                  ],
                )
                : _buildMobileScaffold(),
      ),
    );
  }

  Widget _buildMobileScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          color: Colors.white,
          elevation: 8,
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                _buildTabItem(
                  index: 0,
                  imagePath: 'assets/images/icons/Social.png',
                  label: 'Social',
                ),
                _buildTabItem(
                  index: 1,
                  imagePath: 'assets/images/icons/Community.png',
                  label: 'Community',
                ),
                _buildTabItem(
                  index: 2,
                  imagePath: 'assets/images/icons/Homes.png',
                  label: 'Homes',
                ),
                _buildTabItem(
                  index: 3,
                  imagePath: 'assets/images/icons/Marketplace.png',
                  label: 'Marketplace',
                ),
                _buildTabItem(
                  index: 4,
                  imagePath: 'assets/images/icons/Services.png',
                  label: 'Services',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required String imagePath,
    required String label,
  }) {
    final bool isSelected = _currentIndex == index;
    final Color color = isSelected ? Colors.black : Colors.grey;
    final FontWeight weight = isSelected ? FontWeight.bold : FontWeight.normal;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 24, height: 24, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: _archivoTextStyle(
                fontSize: 10,
                fontWeight: weight,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(String imagePath, int index) {
    final bool isSelected = _currentIndex == index;
    final Color color = isSelected ? Colors.black : Colors.grey;
    return Image.asset(imagePath, width: 24, height: 24, color: color);
  }

  Widget _buildNavLabel(String label, int index) {
    final bool isSelected = _currentIndex == index;
    final Color color = isSelected ? Colors.black : Colors.grey;
    final FontWeight weight = isSelected ? FontWeight.bold : FontWeight.normal;
    return Text(
      label,
      style: _archivoTextStyle(fontSize: 12, fontWeight: weight, color: color),
    );
  }
}
