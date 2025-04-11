import 'package:flutter/material.dart';
import 'package:getaccess/util/constants/colors.dart';

import '../widgets/quick_access_card.dart';
import '../widgets/social_services_card.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final TextEditingController searchController = TextEditingController();
  final PageController _noticePageController = PageController();
  int _currentNoticePage = 0;

  // Sample notice data
  final List<Map<String, dynamic>> _notices = [
    {
      'category': 'Society',
      'timeAgo': '6d ago',
      'title': 'Attention Residents',
      'content': 'Water tank cleaning is scheduled for Friday, 10 AM - 2 PM. Water supply may be interrupted during this time. Please plan accordingly',
    },
    {
      'category': 'Society',
      'timeAgo': '2d ago',
      'title': 'Monthly Meeting',
      'content': 'Monthly society meeting will be held on Sunday at 11 AM in the community hall. All residents are requested to attend.',
    },
    {
      'category': 'Maintenance',
      'timeAgo': '1d ago',
      'title': 'Elevator Maintenance',
      'content': 'Elevator maintenance is scheduled for Saturday from 9 AM to 12 PM. Please use stairs during this period.',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Listen for search text changes
    searchController.addListener(() => setState(() {}));

    // Add listener for page changes in carousel
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
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    print('Searching for: $query');
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width to make layout responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth > 600 ? 40 : 20;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Header with location and notification
                Row(
                  children: [
                    CircleAvatar(
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
                    const SizedBox(width: 8),
                    Text(
                      'Block B,105',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.notifications_none_outlined,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(12),
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
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
                Text(
                  'Quick Access',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 16),

                // Quick Access Cards
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildQuickAccessCard(
                            "assets/images/icons/All Icons.png",
                            "Pre-Approval"
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickAccessCard(
                            "assets/images/icons/Vector (1).png",
                            "Daily help"
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickAccessCard(
                            "assets/images/icons/car.side.arrowtriangle.down.png",
                            "Cab"
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildQuickAccessCard(
                            "assets/images/icons/Group (2).png",
                            "Visit Home"
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Notice Carousel
                Container(
                  height: 230,
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
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
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
                                    borderRadius: BorderRadius.circular(8),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(4),
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
                          color: _currentNoticePage == index
                              ? Colors.black
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Services section
                Text(
                  'Services',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 16),

                // Services Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio:1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
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
                  ],
                ),

                const SizedBox(height: 24),
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
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 36,
            width: 36,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}