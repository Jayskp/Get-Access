import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getaccess/Settings.dart';
import 'package:getaccess/notification.dart';
import 'package:getaccess/util/constants/colors.dart';

import '../../widgets/social_services_card.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final TextEditingController searchController = TextEditingController();
  final PageController _noticePageController = PageController();
  int _currentNoticePage = 0;
  bool _isDropdownOpen = false;
  bool _showAddPropertyForm = false;
  String _selectedPropertyType = 'Flat';
  final TextEditingController _propertyNameController = TextEditingController();
  final TextEditingController _propertyAddressController =
      TextEditingController();

  // Sample notice data
  final List<Map<String, dynamic>> _notices = [
    {
      'category': 'Society',
      'timeAgo': '6d ago',
      'title': 'Attention Residents',
      'content':
          'Water tank cleaning is scheduled for Friday, 10 AM - 2 PM. Water supply may be interrupted during this time. Please plan accordingly',
    },
    {
      'category': 'Society',
      'timeAgo': '2d ago',
      'title': 'Monthly Meeting',
      'content':
          'Monthly society meeting will be held on Sunday at 11 AM in the community hall. All residents are requested to attend.',
    },
    {
      'category': 'Maintenance',
      'timeAgo': '1d ago',
      'title': 'Elevator Maintenance',
      'content':
          'Elevator maintenance is scheduled for Saturday from 9 AM to 12 PM. Please use stairs during this period.',
    },
  ];

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => setState(() {}));
    _noticePageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    if (_noticePageController.page!.round() != _currentNoticePage) {
      setState(() {
        _currentNoticePage = _noticePageController.page!.round();
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _noticePageController.removeListener(_onPageChanged);
    _noticePageController.dispose();
    _propertyNameController.dispose();
    _propertyAddressController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (kDebugMode) {
      print('Searching for: $query');
    }
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
      if (_showAddPropertyForm) {
        _showAddPropertyForm = false;
      }
    });
  }

  void _showAddPropertyDialog() {
    setState(() {
      _isDropdownOpen = false;
      _showAddPropertyForm = true;
      _propertyNameController.clear();
      _propertyAddressController.clear();
      _selectedPropertyType = 'Flat';
    });
  }

  void _submitPropertyForm() {
    if (kDebugMode) {
      print('Adding property: $_selectedPropertyType');
      print('Name: ${_propertyNameController.text}');
      print('Address: ${_propertyAddressController.text}');
    }
    setState(() {
      _showAddPropertyForm = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_selectedPropertyType added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive width calculations
    final screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding =
        screenWidth > 1024 ? 64 : (screenWidth > 600 ? 40 : 20);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // Calculate if we're on a larger screen for more responsive design
    final bool isLargeScreen = screenWidth > 768;

    return Scaffold(
      backgroundColor:
          Colors.grey[50], // Lighter background for professional look
      body: SafeArea(
        child: Center(
          child: Container(
            // Professional website layout with centered content and subtle shadow
            constraints: const BoxConstraints(
              maxWidth: 1200,
            ), // Slightly wider for web
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
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Header with location and notification
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsPage(),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFFD4BE45),
                              radius: 18,
                              child: const Text(
                                'D',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _toggleDropdown,
                            child: Row(
                              children: [
                                Text(
                                  'Block B,105',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(
                                  _isDropdownOpen
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.notifications_none_outlined,
                                size: 24,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationPage(),
                                  ),
                                );
                              },
                              tooltip: 'Notifications',
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Search bar
                      Container(
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
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                Icons.search,
                                size: 24,
                                color: Colors.grey,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                onSubmitted: _onSearchSubmitted,
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                    fontSize: 16,
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
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  searchController.clear();
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Quick Access section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quick Access',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Customize',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Quick Access Cards (same row as before)
                      SizedBox(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildQuickAccessCard(
                                "assets/images/icons/All Icons.png",
                                "Pre-Approval",
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildQuickAccessCard(
                                "assets/images/icons/Vector (1).png",
                                "Daily help",
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildQuickAccessCard(
                                "assets/images/icons/car.side.arrowtriangle.down.png",
                                "Cab",
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildQuickAccessCard(
                                "assets/images/icons/Group (2).png",
                                "Visit Home",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Notice section header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Notices',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Notice Carousel
                      SizedBox(
                        height: isPortrait ? 230 : 170,
                        child: PageView.builder(
                          controller: _noticePageController,
                          itemCount: _notices.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentNoticePage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final notice = _notices[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    offset: const Offset(0, 2),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.grey[100]!,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '=',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Notice',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  'Admin',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${notice['category']} • ${notice['timeAgo']}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    notice['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notice['content'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Carousel indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _notices.length,
                          (index) => GestureDetector(
                            onTap: () {
                              _noticePageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    _currentNoticePage == index
                                        ? Colors.black
                                        : Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Services section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Services',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Responsive Services Grid modeled after the Marketplace Categories grid.
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                              screenWidth > 1024
                                  ? 240
                                  : (screenWidth > 600 ? 200 : 150),
                          childAspectRatio: isLargeScreen ? 0.98 : 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          // Using the same service cards as before
                          final serviceCards = [
                            ServiceCard(
                              image: 'assets/images/daily help.png',
                              title: 'Daily help',
                              onTap: () {},
                            ),
                            ServiceCard(
                              image: 'assets/images/helpdesk.png',
                              title: 'Helpdesk',
                              onTap: () {},
                            ),
                            ServiceCard(
                              image: 'assets/images/home serivce.png',
                              title: 'Salon',
                              onTap: () {},
                            ),
                            ServiceCard(
                              image: 'assets/images/market.png',
                              title: 'Groceries',
                              onTap: () {},
                            ),
                          ];
                          return serviceCards[index];
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                // Dropdown overlay
                if (_isDropdownOpen)
                  Positioned(
                    top: 60,
                    left: horizontalPadding,
                    right: horizontalPadding,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.home_outlined,
                                  size: 22,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'C-105 Sahaj Flat',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Members',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '3',
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _showAddPropertyDialog,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.add_circle_outline,
                                    size: 22,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Add Flat/Home/Villa',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Add Property Form overlay
                if (_showAddPropertyForm)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Center(
                        child: Container(
                          width: screenWidth - 48,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Add New Property',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        _showAddPropertyForm = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Property Type Selection
                              Text(
                                'Property Type',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _selectedPropertyType,
                                    items:
                                        [
                                          'Flat',
                                          'House',
                                          'Villa',
                                          'Building',
                                        ].map((type) {
                                          return DropdownMenuItem<String>(
                                            value: type,
                                            child: Text(type),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPropertyType = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Property Name
                              Text(
                                'Property Name/Number',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _propertyNameController,
                                decoration: InputDecoration(
                                  hintText: 'e.g. C-105, Villa 23',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Property Address
                              Text(
                                'Property Address',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _propertyAddressController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'Enter complete address',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _submitPropertyForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Add Property',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard(String imagePath, String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4FFF4),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 36,
            width: 36,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
