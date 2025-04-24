import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getaccess/PreApproveCab.dart';
import 'package:getaccess/PreApproveDelivery.dart';
import 'package:getaccess/PreApproveMaid.dart';
import 'package:getaccess/Settings.dart';
import 'package:getaccess/daily_help.dart';
// import 'package:getaccess/models/social_post.dart';
import 'package:getaccess/notification.dart';
import 'package:getaccess/providers/social_post_provider.dart';
import 'package:getaccess/screens/InviteGuest.dart';
import 'package:getaccess/screens/Social%20screen/social_shimmer.dart';
import 'package:getaccess/util/constants/colors.dart';
import 'package:getaccess/widgets/social_post_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:getaccess/screens/Admin/admin_dashboard.dart';
import 'package:getaccess/providers/announcement_provider.dart';

import '../../NewEvent.dart';
import '../../NewPoll.dart';
import '../../NewPost.dart';
import '../../messages.dart';
import '../../widgets/social_services_card.dart';

class SocialScreen extends StatefulWidget {
  final bool isAdmin;

  const SocialScreen({super.key, this.isAdmin = false});

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  final PageController _noticePageController = PageController();
  int _currentNoticePage = 0;
  bool _isDropdownOpen = false;
  bool _showAddPropertyForm = false;
  bool _showQuickAccessPopup = false;
  bool _isCustomizing = false;
  String _selectedPropertyType = 'Flat';
  final TextEditingController _propertyNameController = TextEditingController();
  final TextEditingController _propertyAddressController =
      TextEditingController();

  // For sticky header
  final ScrollController _scrollController = ScrollController();
  bool _isQuickAccessSticky = false;
  late final double _quickAccessThreshold =
      150.0; // Position at which the tab becomes sticky

  // For animations
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> preApproveItems = [
    {"icon": Icons.person_outline, "title": "Guest", "page": InviteGuest()},
    {
      "icon": Icons.directions_car_outlined,
      "title": "Cab",
      "page": PreApproveCab(),
    },
    {
      "icon": Icons.delivery_dining_outlined,
      "title": "Delivery",
      "page": PreApproveDelivery(),
    },
    {
      "icon": Icons.build_outlined,
      "title": "Visiting\nHelp",
      "page": PreApproveMaid(),
    },
  ];
  final List<Map<String, dynamic>> securityItems = [
    {
      "icon": Icons.phone_outlined,
      "title": "Call\nSecurity",
      "page": GuestEntryPage(),
    },
    {
      "icon": Icons.message_outlined,
      "title": "Message\nGuard",
      "page": Messages(),
    },
    {
      "icon": Icons.car_repair_outlined,
      "title": "Search a\nVehicle",
      "page": GuestEntryPage(),
    },
    {
      "icon": Icons.child_care_outlined,
      "title": "Allow Kid\nExit",
      "page": GuestEntryPage(),
    },
  ];
  final List<Map<String, dynamic>> createPostItems = [
    {
      "icon": Icons.post_add_outlined,
      "title": "Create\nPost",
      "page": NewPostPage(),
    },
    {
      "icon": Icons.poll_outlined,
      "title": "Start\nPoll",
      "page": NewPollPage(),
    },
    {
      "icon": Icons.card_giftcard_outlined,
      "title": "Sell or\nGiveaway",
      "page": GuestEntryPage(),
    },
    {
      "icon": Icons.event_outlined,
      "title": "Host\nEvent",
      "page": NewEventPage(),
    },
    {
      "icon": Icons.home_work_outlined,
      "title": "List a\nproperty",
      "page": GuestEntryPage(),
    },
  ];

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

  // All available items for customization
  List<Map<String, dynamic>> allAvailableItems = [];

  // Fixed set of 4 quick access items
  List<Map<String, dynamic>> quickAccessItems = [
    {
      "icon": Icons.person_outline,
      "title": "Pre-Approval",
      "function": "_showPreApprovalDialog",
      "page": null,
    },
    {
      "icon": Icons.build_outlined,
      "title": "Daily help",
      "function": null,
      "page": DailyHelp(),
    },
    {
      "icon": Icons.directions_car_outlined,
      "title": "Cab",
      "function": "_showCabDialog",
      "page": null,
    },
    {
      "icon": Icons.medical_services_outlined,
      "title": "Visit Home",
      "function": "_showVisitingHelpDialog",
      "page": null,
    },
  ];

  // Items not in quick access
  List<Map<String, dynamic>> get availableItemsForSwap {
    return allAvailableItems.where((item) {
      // Check if this item is not already in quickAccessItems
      return !quickAccessItems.any(
        (quickItem) => quickItem['title'] == item['title'],
      );
    }).toList();
  }

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

  Widget _buildQuickAccessItem(
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
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
      ),
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

  // Helper method for option cards in the popup
  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF4A4A4A)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: _archivoTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: _archivoTextStyle(
              fontSize: 10,
              color: const Color(0xFF666666),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showPreApprovalDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // Main Container
                Container(
                  width: 340,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and close button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Guest Invite',
                            style: _archivoTextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(dialogContext),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Image(
                                image: AssetImage(
                                  "assets/images/icons/close-outline.png",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pre-approve expected visitors for a seamless and\nhassle-free entry experience.',
                        style: _archivoTextStyle(
                          fontSize: 12,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // First row of options
                      Row(
                        children: [
                          Expanded(
                            child: _buildOptionCard(
                              icon: Icons.person_add_outlined,
                              title: 'Quick Invite',
                              description:
                                  'Manually approve guests for smooth entry. Ideal for small, personal gatherings.',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildOptionCard(
                              icon: Icons.groups_outlined,
                              title: 'Party/Group Invite',
                              description:
                                  'Generate a shared invite link with guest limits for easy tracking during large events.',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Second row of options
                      Row(
                        children: [
                          Expanded(
                            child: _buildOptionCard(
                              icon: Icons.repeat_outlined,
                              title: 'Frequent Invite',
                              description:
                                  'Provide regular visitors with a single passcode, avoiding the need for repeated approvals.',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildOptionCard(
                              icon: Icons.lock_outline,
                              title: 'Private Invite',
                              description:
                                  'Create exclusive access codes for VIP guests ensuring heightened security and privacy.',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showVisitingHelpDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: 340,
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'VISITING HELP CATEGORY',
                            style: _archivoTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4A4A4A),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(dialogContext),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Image(
                                image: AssetImage(
                                  "assets/images/icons/close-outline.png",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Category List
                      ..._buildCategoryItems(),
                    ],
                  ),
                ),
                // Floating Icon
                Positioned(
                  top: -40,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.build_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildCategoryItems() {
    final categories = [
      'Home repair',
      'Application repair',
      'Internet repair',
      'Spa',
      'Tutor',
      'Other',
    ];

    return categories.map((category) {
      return Column(
        children: [
          InkWell(
            onTap: () {
              // Handle category selection
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category,
                    style: _archivoTextStyle(
                      fontSize: 16,
                      color: const Color(0xFF4A4A4A),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF4A4A4A),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => setState(() {}));
    _noticePageController.addListener(_onPageChanged);
    loadData();
    _initAllAvailableItems(); // Initialize available items

    // Set up scroll controller and listener for sticky header
    _scrollController.addListener(_updateHeaderPosition);

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Initialize sample posts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SocialPostProvider>(context, listen: false).addSamplePosts();
    });

    // Load announcements when screen initializes
    Future.microtask(() {
      Provider.of<AnnouncementProvider>(
        context,
        listen: false,
      ).loadAnnouncements();
    });
  }

  void _onPageChanged() {
    if (_noticePageController.page!.round() != _currentNoticePage) {
      setState(() {
        _currentNoticePage = _noticePageController.page!.round();
      });
    }
  }

  bool _isLoading = false;

  Future<void> loadData() async {
    print("Starting to load data...");
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      print("Data loading complete");
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print("_isLoading set to false");
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _noticePageController.removeListener(_onPageChanged);
    _noticePageController.dispose();
    _propertyNameController.dispose();
    _propertyAddressController.dispose();
    _scrollController.removeListener(_updateHeaderPosition);
    _scrollController.dispose();
    _animationController.dispose();
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
        _isCustomizing = false;
      });
    } else {
      setState(() {
        _showQuickAccessPopup = true;
      });

      // Content to show in the bottom sheet
      Widget bottomSheetContent() {
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
            child:
                _isCustomizing
                    ? _buildCustomizationView()
                    : _buildQuickAccessPopupContent(),
          ),
        );
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => bottomSheetContent(),
      ).then((_) {
        setState(() {
          _showQuickAccessPopup = false;
          _isCustomizing = false;
        });
      });
    }
  }

  Widget _buildCustomizationView() {
    return StatefulBuilder(
      builder: (context, setState) {
        // Get all available items without categorization
        List<Map<String, dynamic>> availableItems = _getAvailableItems();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
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

            // Title and Done button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('Customize Quick Access'),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Drag & Drop interface
            Text(
              'Drag items to rearrange your Quick Access bar:',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),

            const SizedBox(height: 20),

            // Quick access items (draggable)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Quick Access Items',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  ReorderableGridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    children: List.generate(quickAccessItems.length, (index) {
                      final item = quickAccessItems[index];
                      return _buildDraggableQuickAccessItem(
                        key: ValueKey('quickAccess$index'),
                        item: item,
                        index: index,
                      );
                    }),
                    onReorder: (oldIndex, newIndex) {
                      // Update the state
                      setState(() {
                        if (oldIndex < newIndex) newIndex -= 1;
                        final item = quickAccessItems.removeAt(oldIndex);
                        quickAccessItems.insert(newIndex, item);
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Available items section title
            Text(
              'Available items to swap (tap to add):',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),

            const SizedBox(height: 16),

            // All available items in a single horizontal scrollable row
            Container(
              height: 110, // Increased height to accommodate square cards
              margin: const EdgeInsets.only(bottom: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      availableItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildAvailableItem(
                            item: item,
                            onTap: () => _showReplaceItemDialog(context, item),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getAvailableItems() {
    // Get items from allAvailableItems that are not in quickAccessItems
    return allAvailableItems.where((item) {
      return !quickAccessItems.any(
        (quickItem) => quickItem['title'] == item['title'],
      );
    }).toList();
  }

  void _showReplaceItemDialog(
    BuildContext context,
    Map<String, dynamic> newItem,
  ) {
    // Check if the item is already in the quickAccessItems
    final bool isAlreadyInQuickAccess = quickAccessItems.any(
      (item) => item['title'] == newItem['title'],
    );

    if (isAlreadyInQuickAccess) {
      // Show notification if the item already exists
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newItem['title']} is already in your Quick Access'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Replace Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select an item to replace:'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(quickAccessItems.length, (index) {
                  final item = quickAccessItems[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        quickAccessItems[index] = newItem;
                      });
                      Navigator.of(context).pop();

                      // Show confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Quick Access updated'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(item['icon'] as IconData, size: 24),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 70,
                          child: Text(
                            item['title'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDraggableQuickAccessItem({
    required Key key,
    required Map<String, dynamic> item,
    required int index,
  }) {
    return Container(
      key: key,
      width: 80, // Fixed width matching available items
      height: 80, // Fixed height matching available items
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'] as IconData, size: 28, color: Colors.black87),
                const SizedBox(height: 4),
                Text(
                  item['title'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black87,
                    height: 1.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.drag_indicator,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableItem({
    required Map<String, dynamic> item,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80, // Fixed width for consistent appearance
        height: 80, // Equal height to width for square appearance
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 28,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['title'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black87,
                      height: 1.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessPopupContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            children:
                preApproveItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: _buildQuickAccessItem(
                      item['icon'] as IconData,
                      item['title'] as String,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _showQuickAccessPopup = false;
                        });
                        final Widget? page = item['page'] as Widget?;
                        if (page != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => page),
                          );
                        }
                      },
                    ),
                  );
                }).toList(),
          ),
        ),

        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Security'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_active_outlined, size: 20),
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
            children:
                securityItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: _buildQuickAccessItem(
                      item['icon'] as IconData,
                      item['title'] as String,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _showQuickAccessPopup = false;
                        });
                        final Widget? page = item['page'] as Widget?;
                        if (page != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => page),
                          );
                        }
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 32),
        _buildSectionTitle('Create post'),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                createPostItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: _buildQuickAccessItem(
                      item['icon'] as IconData,
                      item['title'] as String,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _showQuickAccessPopup = false;
                        });
                        final Widget? page = item['page'] as Widget?;
                        if (page != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => page),
                          );
                        }
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  void _executeQuickAccessAction(Map<String, dynamic> item) {
    // Execute the correct action based on the item
    if (item["function"] == "_showPreApprovalDialog") {
      _showPreApprovalDialog();
    } else if (item["function"] == "_showCabDialog") {
      _showCabDialog();
    } else if (item["function"] == "_showVisitingHelpDialog") {
      _showVisitingHelpDialog();
    } else if (item["page"] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => item["page"]),
      );
    }
  }

  void _updateHeaderPosition() {
    final isSticky =
        _scrollController.hasClients &&
        _scrollController.offset > _quickAccessThreshold;

    if (isSticky != _isQuickAccessSticky) {
      setState(() {
        _isQuickAccessSticky = isSticky;
      });

      if (_isQuickAccessSticky) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _showCabDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) {
        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 328,
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'CAB',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Allow Once',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Don't Allow",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Allow Frequently',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A4A4A),
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
                  backgroundColor: AppColors.primaryGreen,
                  child: const Icon(
                    Icons.directions_car,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => Navigator.of(dialogContext).pop(),
                  child: Image.asset("assets/images/icons/close-outline.png"),
                ),
              ),
            ],
          ),
        );
      },
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
      body: RefreshIndicator(
        onRefresh: loadData,
        child: SafeArea(
          child: Center(
            child:
                _isLoading
                    ? SizedBox.expand(child: SocialShimmer())
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
                                    color: Colors.black.withOpacity(0.05),
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
                          // Main scrollable content
                          CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding,
                                    vertical: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Header with location and notification
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          SettingsPage(),
                                                ),
                                              );
                                            },
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      widget.isAdmin
                                                          ? Colors.blue.shade700
                                                          : const Color(
                                                            0xFFD4BE45,
                                                          ),
                                                  radius: 18,
                                                  child: Text(
                                                    widget.isAdmin ? 'A' : 'D',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                if (widget.isAdmin)
                                                  Positioned(
                                                    right: 0,
                                                    bottom: 0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.red.shade600,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: const Icon(
                                                        Icons
                                                            .admin_panel_settings,
                                                        color: Colors.white,
                                                        size: 10,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: _toggleDropdown,
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Block B,105',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                                Icon(
                                                  _isDropdownOpen
                                                      ? Icons.keyboard_arrow_up
                                                      : Icons
                                                          .keyboard_arrow_down,
                                                  color: Colors.black87,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          if (widget.isAdmin)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                right: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade600,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    // Navigate to admin dashboard
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                AdminDashboardScreen(),
                                                      ),
                                                    );
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 8,
                                                        ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .admin_panel_settings_outlined,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          'Admin',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: IconButton(
                                              icon: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              NotificationPage(),
                                                    ),
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons
                                                      .notifications_none_outlined,
                                                  size: 24,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              onPressed: () {},
                                              tooltip: 'Notifications',
                                              padding: const EdgeInsets.all(8),
                                              constraints:
                                                  const BoxConstraints(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      // Search bar
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGrey,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
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
                                            if (searchController
                                                .text
                                                .isNotEmpty)
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
                                      // Quick Access section - original position
                                      _buildQuickAccessSection(),
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
                                          Row(
                                            children: [
                                              if (widget.isAdmin)
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    right: 12,
                                                  ),
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      // Admin action to add new notice
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Add Notice feature coming soon',
                                                          ),
                                                          backgroundColor:
                                                              Colors.blue,
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.add,
                                                      size: 16,
                                                    ),
                                                    label: Text('Add'),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.green.shade600,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 0,
                                                          ),
                                                      minimumSize: Size(0, 32),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                    ),
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
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      // Notice Carousel
                                      SizedBox(
                                        height: isLargeScreen ? 130.0 : 160.0,
                                        child: Consumer<AnnouncementProvider>(
                                          builder: (
                                            context,
                                            announcementProvider,
                                            child,
                                          ) {
                                            final notices =
                                                announcementProvider
                                                    .announcements;

                                            if (announcementProvider
                                                .isLoading) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }

                                            if (notices.isEmpty) {
                                              return Center(
                                                child: Text(
                                                  'No Notices available',
                                                  style: _archivoTextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              );
                                            }

                                            return PageView.builder(
                                              controller: _noticePageController,
                                              itemCount: notices.length,
                                              onPageChanged: (index) {
                                                setState(() {
                                                  _currentNoticePage = index;
                                                });
                                              },
                                              itemBuilder: (context, index) {
                                                final notice = notices[index];
                                                return Container(
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.lightGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.05),
                                                        blurRadius: 5,
                                                        offset: const Offset(
                                                          0,
                                                          2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                    16,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          if (notice
                                                              .isImportant) ...[
                                                            const Icon(
                                                              Icons
                                                                  .priority_high,
                                                              color: Colors.red,
                                                              size: 16,
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                          ],
                                                          Expanded(
                                                            child: Text(
                                                              notice.title,
                                                              style: _archivoTextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    notice.isImportant
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .black,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            notice.timeAgo,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors
                                                                      .grey[600],
                                                              fontSize: 14.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Expanded(
                                                        child: Text(
                                                          notice.content,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 14.0,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                          maxLines: 3,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Carousel indicators
                                      Consumer<AnnouncementProvider>(
                                        builder: (context, provider, child) {
                                          final count =
                                              provider.announcements.length;

                                          if (count == 0) {
                                            return Container(); // Return empty container if no announcements
                                          }

                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                              count,
                                              (index) => GestureDetector(
                                                onTap: () {
                                                  _noticePageController
                                                      .animateToPage(
                                                        index,
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 300,
                                                            ),
                                                        curve: Curves.easeInOut,
                                                      );
                                                },
                                                child: Container(
                                                  width: 8.0,
                                                  height: 8.0,
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        _currentNoticePage ==
                                                                index
                                                            ? Colors.black
                                                            : Colors.grey[300],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 24),
                                      // Social Feed Section
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Social Feed',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      // Feed Posts
                                      Consumer<SocialPostProvider>(
                                        builder: (context, provider, child) {
                                          final posts = provider.posts;
                                          if (posts.isEmpty) {
                                            return Container(
                                              height: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.article_outlined,
                                                    size: 40,
                                                    color: Colors.grey[400],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'No posts yet',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  const NewPostPage(),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                      'Create a post',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          return Column(
                                            children:
                                                posts
                                                    .map(
                                                      (post) => SocialPostCard(
                                                        post: post,
                                                        onReport: (String) {},
                                                      ),
                                                    )
                                                    .toList(),
                                          );
                                        },
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
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  screenWidth > 1024
                                                      ? 4
                                                      : (screenWidth > 600
                                                          ? 3
                                                          : 2),
                                              childAspectRatio:
                                                  screenWidth > 1024
                                                      ? 0.98
                                                      : (screenWidth > 600
                                                          ? 0.8
                                                          : 1),
                                              crossAxisSpacing: 16,
                                              mainAxisSpacing: 16,
                                            ),
                                        itemCount: serviceCards.length,
                                        itemBuilder:
                                            (context, index) =>
                                                serviceCards[index],
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Sticky header that appears when scrolling
                          if (_isQuickAccessSticky)
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: SafeArea(
                                      child: _buildQuickAccessSection(
                                        inHeader: true,
                                      ),
                                    ),
                                  ),
                                ),
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
                                      color: Colors.black.withOpacity(0.1),
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
                          if (_showAddPropertyForm)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
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
    );
  }

  // Quick access section that can be reused
  Widget _buildQuickAccessSection({bool inHeader = false}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;
    final isWebScreen = screenWidth > 1024;

    // Calculate horizontal padding - more for web
    final horizontalPadding =
        inHeader ? (isWebScreen ? 60.0 : (isLargeScreen ? 40.0 : 20.0)) : 0.0;

    // Fixed card sizing (don't increase for web)
    final cardWidth = 100.0;
    final cardHeight = inHeader ? 70.0 : 80.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Get available width first
        final availableWidth =
            constraints.maxWidth != double.infinity
                ? constraints.maxWidth
                : screenWidth - (horizontalPadding * 2);

        // Now calculate these values
        final totalCardWidth = cardWidth * quickAccessItems.length;
        final remainingSpace = availableWidth - totalCardWidth;
        final cardSpacing =
            isWebScreen ? remainingSpace / (quickAccessItems.length - 1) : 10.0;

        return Container(
          color: inHeader ? Colors.white : Colors.transparent,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: inHeader ? (isWebScreen ? 6.0 : 12.0) : 0,
            horizontal: horizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!inHeader)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Access',
                      style: _archivoTextStyle(
                        fontSize: isWebScreen ? 22 : 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isCustomizing = true;
                        });
                        _toggleQuickAccessPopup();
                      },
                      child: Text(
                        'Customize',
                        style: _archivoTextStyle(
                          fontSize: isWebScreen ? 14 : 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              if (!inHeader) SizedBox(height: isWebScreen ? 12.0 : 10.0),

              // Use a centered row for web view and SingleChildScrollView for mobile
              Container(
                height: cardHeight,
                child:
                    isWebScreen
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(quickAccessItems.length, (
                            index,
                          ) {
                            final item = quickAccessItems[index];
                            return SizedBox(
                              width: cardWidth,
                              height: cardHeight,
                              child: _buildQuickAccessCard(
                                item,
                                iconSize: isWebScreen ? 24.0 : 20.0,
                                fontSize: isWebScreen ? 12.0 : 10.0,
                                isWebView: true,
                              ),
                            );
                          }),
                        )
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(quickAccessItems.length, (
                              index,
                            ) {
                              final item = quickAccessItems[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right:
                                      index < quickAccessItems.length - 1
                                          ? 10.0
                                          : 0,
                                ),
                                child: SizedBox(
                                  width: cardWidth,
                                  height: cardHeight,
                                  child: _buildQuickAccessCard(
                                    item,
                                    iconSize: 20.0,
                                    fontSize: 10.0,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickAccessCard(
    Map<String, dynamic> item, {
    required double iconSize,
    required double fontSize,
    bool isWebView = false,
  }) {
    return InkWell(
      onTap: () => _executeQuickAccessAction(item),
      borderRadius: BorderRadius.circular(isWebView ? 8 : 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(isWebView ? 8 : 12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item['icon'] as IconData,
              size: iconSize,
              color: Colors.black87,
            ),
            SizedBox(height: isWebView ? 2 : 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isWebView ? 2 : 4),
              child: Text(
                item['title'] as String,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.black87,
                  height: 1.1,
                  fontWeight: isWebView ? FontWeight.w500 : FontWeight.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // This method ensures that the items shown match those in the popup
  void _initAllAvailableItems() {
    // Clear existing items and start fresh
    allAvailableItems = [];

    // Add pre-approve items - first category in popup
    for (var item in preApproveItems) {
      allAvailableItems.add({
        "icon": item["icon"] as IconData,
        "title": item["title"] as String,
        "function":
            item["title"] == "Cab"
                ? "_showCabDialog"
                : item["title"] == "Visiting\nHelp"
                ? "_showVisitingHelpDialog"
                : null,
        "page": item["page"],
        "category": "Pre-approve entry",
      });
    }

    // Add security items - second category in popup
    for (var item in securityItems) {
      allAvailableItems.add({
        "icon": item["icon"] as IconData,
        "title": item["title"] as String,
        "function": null,
        "page": item["page"],
        "category": "Security",
      });
    }

    // Add create post items - third category in popup
    for (var item in createPostItems) {
      allAvailableItems.add({
        "icon": item["icon"] as IconData,
        "title": item["title"] as String,
        "function": null,
        "page": item["page"],
        "category": "Create post",
      });
    }
  }
}

class ReorderableGridView extends StatefulWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final Function(int oldIndex, int newIndex) onReorder;

  const ReorderableGridView.count({
    Key? key,
    required this.children,
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.childAspectRatio,
    required this.onReorder,
    required bool shrinkWrap,
    required NeverScrollableScrollPhysics physics,
  }) : super(key: key);

  @override
  _ReorderableGridViewState createState() => _ReorderableGridViewState();
}

class _ReorderableGridViewState extends State<ReorderableGridView> {
  @override
  Widget build(BuildContext context) {
    return ReorderableWrap(
      spacing: widget.crossAxisSpacing,
      runSpacing: widget.mainAxisSpacing,
      children: widget.children,
      onReorder: widget.onReorder,
      buildDraggableFeedback: (context, constraints, child) {
        return Material(
          elevation: 6.0,
          color: Colors.transparent,
          child: Container(
            width:
                (MediaQuery.of(context).size.width -
                    (widget.crossAxisSpacing * (widget.crossAxisCount - 1)) -
                    48) /
                widget.crossAxisCount,
            child: child,
          ),
        );
      },
    );
  }
}

// This is a simplified ReorderableWrap to make the drag-and-drop work
class ReorderableWrap extends StatefulWidget {
  final List<Widget> children;
  final void Function(int oldIndex, int newIndex) onReorder;
  final double spacing;
  final double runSpacing;
  final Widget Function(BuildContext, BoxConstraints, Widget)
  buildDraggableFeedback;

  const ReorderableWrap({
    Key? key,
    required this.children,
    required this.onReorder,
    this.spacing = 0,
    this.runSpacing = 0,
    required this.buildDraggableFeedback,
  }) : super(key: key);

  @override
  _ReorderableWrapState createState() => _ReorderableWrapState();
}

class _ReorderableWrapState extends State<ReorderableWrap> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      children: List.generate(widget.children.length, (index) {
        return LongPressDraggable<int>(
          data: index,
          child: DragTarget<int>(
            onWillAcceptWithDetails: (data) => data.data != index,
            onAcceptWithDetails: (data) {
              widget.onReorder(data as int, index);
            },
            builder: (context, candidateData, rejectedData) {
              return widget.children[index];
            },
          ),
          feedback: widget.buildDraggableFeedback(
            context,
            BoxConstraints(),
            widget.children[index],
          ),
          childWhenDragging: Opacity(
            opacity: 0.2,
            child: widget.children[index],
          ),
        );
      }),
    );
  }
}

class GuestEntryPage {
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('comming soon')));
  }
}
