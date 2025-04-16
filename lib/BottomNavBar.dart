import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getaccess/NewEvent.dart';
import 'package:getaccess/PreApproveCab.dart';
import 'package:getaccess/PreApproveDelivery.dart';
import 'package:getaccess/PreApproveMaid.dart';
import 'package:getaccess/screens/Community/community_screen.dart';
import 'package:getaccess/screens/Marketplace/marketplace.dart';
import 'package:getaccess/screens/Search%20Home/search_home_screen.dart';
import 'package:getaccess/screens/Services/Service_screen.dart';
import 'package:getaccess/screens/Social%20screen/social_screen.dart';

class BottomNavBarDemo extends StatefulWidget {
  const BottomNavBarDemo({Key? key}) : super(key: key);

  @override
  State<BottomNavBarDemo> createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<BottomNavBarDemo> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    SocialScreen(),
    CommunityScreen(),
    SearchHomeScreen(),
    Marketplace(),
    PreApproveMaid(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 600;
    return Scaffold(
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
                        icon: _buildNavIcon('assets/images/icons/Homes.png', 2),
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
    );
  }

  Widget _buildMobileScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          color: Colors.white,
          child: Container(
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
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath, width: 24, height: 24, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: weight,
                  fontSize: 10,
                ),
              ),
            ],
          ),
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
      style: TextStyle(color: color, fontWeight: weight, fontSize: 12),
    );
  }
}
