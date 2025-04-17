import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getaccess/screens/Social screen/social_shimmer.dart';
import 'package:getaccess/Settings.dart';
import 'package:getaccess/util/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool _showQuickAccessPopup = false;
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

  final List<Map<String, String>> quickAccessItems = [
    {"iconPath": "assets/images/icons/All Icons.png", "title": "Pre-Approval"},
    {"iconPath": "assets/images/icons/Vector (1).png", "title": "Daily help"},
    {
      "iconPath": "assets/images/icons/car.side.arrowtriangle.down.png",
      "title": "Cab",
    },
    {"iconPath": "assets/images/icons/Group (2).png", "title": "Visit Home"},
  ];

  // Add these sections data
  final List<Map<String, dynamic>> preApproveItems = [
    {"icon": Icons.person_outline, "title": "Guest"},
    {"icon": Icons.directions_car_outlined, "title": "Cab"},
    {"icon": Icons.delivery_dining_outlined, "title": "Delivery"},
    {"icon": Icons.build_outlined, "title": "Visiting\nHelp"},
  ];

  final List<Map<String, dynamic>> securityItems = [
    {"icon": Icons.phone_outlined, "title": "Call\nSecurity"},
    {"icon": Icons.message_outlined, "title": "Message\nGuard"},
    {"icon": Icons.car_repair_outlined, "title": "Search a\nVehicle"},
    {"icon": Icons.child_care_outlined, "title": "Allow Kid\nExit"},
  ];

  final List<Map<String, dynamic>> createPostItems = [
    {"icon": Icons.post_add_outlined, "title": "Create\nPost"},
    {"icon": Icons.poll_outlined, "title": "Start\nPoll"},
    {"icon": Icons.card_giftcard_outlined, "title": "Sell or\nGiveaway"},
    {"icon": Icons.event_outlined, "title": "Host\nEvent"},
    {"icon": Icons.home_work_outlined, "title": "List a\nproperty"},
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

  bool _isLoading = true;
  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
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

  void _toggleQuickAccessPopup() {
    if (_showQuickAccessPopup) {
      Navigator.pop(context);
      setState(() {
        _showQuickAccessPopup = false;
      });
    } else {
      setState(() {
        _showQuickAccessPopup = true;
      });
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar at the top
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Pre-approve entry'),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.mic, size: 20),
                            const SizedBox(width: 8),
                            const Text('Speak'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          preApproveItems
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(right: 24),
                                  child: _buildQuickAccessItem(
                                    item['icon'] as IconData,
                                    item['title'] as String,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Security'),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.notifications_active_outlined,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text('Raise Alert'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          securityItems
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(right: 24),
                                  child: _buildQuickAccessItem(
                                    item['icon'] as IconData,
                                    item['title'] as String,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Create post'),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                          createPostItems
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(right: 24),
                                  child: _buildQuickAccessItem(
                                    item['icon'] as IconData,
                                    item['title'] as String,
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).then((_) {
        setState(() {
          _showQuickAccessPopup = false;
        });
      });
    }
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
      body: RefreshIndicator(
        onRefresh: loadData,
        child: SafeArea(
          child: Center(
            child:
                _isLoading
                    ? SocialShimmer()
                    : Container(
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
                          isLargeScreen
                              ? const EdgeInsets.symmetric(vertical: 16)
                              : null,
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
                            child:CircleAvatar(
                                      backgroundColor: const Color(0xFFD4BE45),
                                      radius: 18,
                                      child: const Text(
                                        'D',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,),
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
                                            color: Colors.black.withValues(
                                              alpha: 0.1,
                                            ),
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
                                        onPressed: () {},
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
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
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
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
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
                                            contentPadding:
                                                const EdgeInsets.symmetric(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Quick Access',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
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
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              barrierColor: Colors.black
                                                  .withValues(alpha: 0.5),
                                              builder:
                                                  (dialogCtx) => Center(
                                                    child: Container(
                                                      width: 340,
                                                      padding:
                                                          const EdgeInsets.fromLTRB(
                                                            20,
                                                            20,
                                                            20,
                                                            24,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              24,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // header
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const Text(
                                                                'Guest Invite',
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    () =>
                                                                        Navigator.of(
                                                                          dialogCtx,
                                                                        ).pop(),
                                                                child: const Icon(
                                                                  Icons.close,
                                                                  size: 24,
                                                                  color: Color(
                                                                    0xFF666666,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          const Text(
                                                            'Pre-approve expected visitors for a seamless and\nhassle-free entry experience.',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                0xFF666666,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          // options grid
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  height: 100,
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                        12,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: const Color(
                                                                      0xFFF2F2F2,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          16,
                                                                        ),
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: const [
                                                                          Icon(
                                                                            Icons.group_add,
                                                                            size:
                                                                                20,
                                                                            color: Color(
                                                                              0xFF4A4A4A,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            'Quick Invite',
                                                                            style: TextStyle(
                                                                              fontSize:
                                                                                  16,
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            6,
                                                                      ),
                                                                      const Text(
                                                                        'Manually approve guests for\nsmooth entry. Ideal for small,\npersonal gatherings.',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Color(
                                                                            0xFF666666,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  height: 100,
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                        12,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: const Color(
                                                                      0xFFF2F2F2,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          16,
                                                                        ),
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: const [
                                                                          Icon(
                                                                            Icons.group,
                                                                            size:
                                                                                20,
                                                                            color: Color(
                                                                              0xFF4A4A4A,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            'Party/Group Invite',
                                                                            style: TextStyle(
                                                                              fontSize:
                                                                                  16,
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            6,
                                                                      ),
                                                                      const Text(
                                                                        'Generate a shared invite link with\nguest limits for easy tracking\nduring large events.',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Color(
                                                                            0xFF666666,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  height: 100,
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                        12,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: const Color(
                                                                      0xFFF2F2F2,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          16,
                                                                        ),
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: const [
                                                                          Icon(
                                                                            Icons.repeat,
                                                                            size:
                                                                                20,
                                                                            color: Color(
                                                                              0xFF4A4A4A,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            'Frequent Invite',
                                                                            style: TextStyle(
                                                                              fontSize:
                                                                                  16,
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            6,
                                                                      ),
                                                                      const Text(
                                                                        'Provide regular visitors with a\nsingle passcode, avoiding the\nneed for repeated approvals.',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Color(
                                                                            0xFF666666,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  height: 100,
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                        12,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color: const Color(
                                                                      0xFFF2F2F2,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          16,
                                                                        ),
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: const [
                                                                          Icon(
                                                                            Icons.lock,
                                                                            size:
                                                                                20,
                                                                            color: Color(
                                                                              0xFF4A4A4A,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          Text(
                                                                            'Private Invite',
                                                                            style: TextStyle(
                                                                              fontSize:
                                                                                  16,
                                                                              fontWeight:
                                                                                  FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            6,
                                                                      ),
                                                                      const Text(
                                                                        'Provide regular visitors with a\nsingle passcode, avoiding the\nneed for repeated approvals.',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Color(
                                                                            0xFF666666,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                            );
                                          },
                                          child: _buildQuickAccessCard(
                                            "assets/images/icons/All Icons.png",
                                            "Pre-Approval",
                                          ),
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
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              barrierColor: Colors.black
                                                  .withValues(alpha: 0.5),
                                              builder: (
                                                BuildContext dialogContext,
                                              ) {
                                                return Center(
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        width: 328,
                                                        padding:
                                                            const EdgeInsets.fromLTRB(
                                                              20,
                                                              60,
                                                              20,
                                                              24,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                24,
                                                              ),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Text(
                                                              'CAB',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                  0xFF4A4A4A,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 24,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Container(
                                                                    height: 44,
                                                                    decoration: BoxDecoration(
                                                                      color: Color(
                                                                        0xFFF2F2F2,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                    ),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: const Text(
                                                                      'Allow Once',
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Color(
                                                                          0xFF4A4A4A,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 16,
                                                                ),
                                                                Expanded(
                                                                  child: Container(
                                                                    height: 44,
                                                                    decoration: BoxDecoration(
                                                                      color: Color(
                                                                        0xFFF2F2F2,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                    ),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: const Text(
                                                                      "Don't Allow",
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Color(
                                                                          0xFF4A4A4A,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 16,
                                                            ),
                                                            Container(
                                                              width:
                                                                  double
                                                                      .infinity,
                                                              height: 44,
                                                              decoration:
                                                                  BoxDecoration(
                                                                    color: Color(
                                                                      0xFFF2F2F2,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          12,
                                                                        ),
                                                                  ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: const Text(
                                                                'Allow Frequently',
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Color(
                                                                    0xFF4A4A4A,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      Positioned(
                                                        top: -40,
                                                        left: 0,
                                                        right: 0,
                                                        child: CircleAvatar(
                                                          radius: 40,
                                                          backgroundColor:
                                                              AppColors
                                                                  .primaryGreen,
                                                          child: const Icon(
                                                            Icons
                                                                .directions_car,
                                                            size: 32,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),

                                                      // ────── close button ──────
                                                      Positioned(
                                                        top: 12,
                                                        right: 12,
                                                        child: GestureDetector(
                                                          onTap:
                                                              () =>
                                                                  Navigator.of(
                                                                    dialogContext,
                                                                  ).pop(),
                                                          child: Image.asset(
                                                            "assets/images/icons/close-outline.png",
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: _buildQuickAccessCard(
                                            "assets/images/icons/car.side.arrowtriangle.down.png",
                                            "Cab",
                                          ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Notices',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
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
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGrey,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.05,
                                              ),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: const Center(
                                                    child: Text(
                                                      '=',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 2,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  4,
                                                                ),
                                                          ),
                                                          child: const Text(
                                                            'Admin',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Services',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
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
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            screenWidth > 1024
                                                ? 240
                                                : (screenWidth > 600
                                                    ? 200
                                                    : 150),
                                        childAspectRatio:
                                            isLargeScreen ? 0.98 : 0.67,
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
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
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
                                              borderRadius:
                                                  BorderRadius.circular(16),
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
                                                  decoration:
                                                      const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                  child: const Center(
                                                    child: Text(
                                                      '3',
                                                      style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Add New Property',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
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
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey[300]!,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value: type,
                                                      child: Text(type),
                                                    );
                                                  }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  _selectedPropertyType =
                                                      value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        // Property Name
                                        Text(
                                          'Property Name/Number',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: _propertyNameController,
                                          decoration: InputDecoration(
                                            hintText: 'e.g. C-105, Villa 23',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Colors.grey[300]!,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        // Property Address
                                        Text(
                                          'Property Address',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller:
                                              _propertyAddressController,
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            hintText: 'Enter complete address',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Colors.grey[300]!,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 32,
                                                    vertical: 12,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: _toggleQuickAccessPopup,
          backgroundColor: AppColors.primaryGreen,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          tooltip: 'Quick Access',
          child: Icon(
            _showQuickAccessPopup ? Icons.close : Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildQuickAccessCard(String imagePath, String label) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 28,
            width: 28,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: _archivoTextStyle(fontSize: 12),
          ),
        ],
    return InkWell(
      onTap: () {
        if (label == "Pre-Approval") {
          _showPreApprovalDialog();
        } else if (label == "Visit Home") {
          _showVisitingHelpDialog();
        }
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: _archivoTextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.lightGrey, // Light beige color
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: 28, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
