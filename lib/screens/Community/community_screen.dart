import 'package:flutter/material.dart';
import 'package:getaccess/ResidentDirectory.dart';
import 'package:getaccess/Search.dart';
import 'package:getaccess/chat.dart';
import 'package:getaccess/screens/Community/community_shimmer.dart';
import 'package:getaccess/util/constants/colors.dart';
import 'package:getaccess/widgets/helpers_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';
import 'package:getaccess/providers/announcement_provider.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController searchController = TextEditingController();
  final PageController _noticePageController = PageController();
  int _currentNoticePage = 0;

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
      "iconPath": "assets/images/icons/vacuum-cleaner.png",
      "title": "Maid",
      "badgeCount": "3",
    },
    {
      "iconPath": "assets/images/icons/chef-hat-one.png",
      "title": "Cook",
      "badgeCount": "2",
    },
    {
      "iconPath": "assets/images/icons/milk-one.png",
      "title": "Milkman",
      "badgeCount": "5",
    },
    {
      "iconPath": "assets/images/icons/Laundry.png",
      "title": "Laundry",
      "badgeCount": "7",
    },
  ];
  bool _isLoading = true;
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
  void initState() {
    super.initState();
    // Listen for search text changes
    loadData();
    // Add listener for page changes in carousel
    _noticePageController.addListener(_onPageChanged);

    // Load announcements
    Future.microtask(() {
      print("Loading announcements in Community");
      Provider.of<AnnouncementProvider>(
        context,
        listen: false,
      ).loadAnnouncements().then(
        (_) => print(
          "Announcements loaded: ${Provider.of<AnnouncementProvider>(context, listen: false).announcements.length}",
        ),
      );
    });
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;
    double horizontalPadding =
        screenWidth > 1024 ? 64 : (screenWidth > 600 ? 40 : 26);
    final _ = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: loadData,
        child: SafeArea(
          child:
              _isLoading
                  ? CommunityShimmer()
                  : Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
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
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  Text(
                                    "Community",
                                    style: _archivoTextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SearchPage(),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.search_rounded, size: 24),
                                    tooltip: 'Search',
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Chat(),
                                        ),
                                      );
                                    },
                                    icon: Image(
                                      image: AssetImage(
                                        "assets/images/icons/bx-chat.png",
                                      ),
                                      height: 24,
                                      width: 24,
                                    ),
                                    tooltip: 'Chat',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // Add Home Town Card
                              DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(15),
                                dashPattern: const [6, 3],
                                color: AppColors.primaryGreen,
                                strokeWidth: 1,
                                padding: EdgeInsets.zero,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: double.maxFinite,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 27,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 62),
                                          child: Image.asset(
                                            "assets/images/icons/fi-rr-home-location.png",
                                            width: 24,
                                            height: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Padding(
                                          padding: EdgeInsets.only(right: 32),
                                          child: Text(
                                            "Add your home town",
                                            style: _archivoTextStyle(
                                              color: AppColors.primaryGreen,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Add Pets Card
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(27),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.pets,
                                        color: Colors.grey,
                                        size: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Add your pets",
                                        style: _archivoTextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Connect Section
                              Text(
                                "Connect",
                                style: _archivoTextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Resident Directory Card
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResidentDirectory(),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(23),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Resident Directory",
                                                    style: _archivoTextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Discover,connect and engage",
                                                style: _archivoTextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Image(
                                          image: AssetImage(
                                            "assets/images/icons/Group 56.png",
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "+350",
                                          style: _archivoTextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              // Find Helpers Section
                              Row(
                                children: [
                                  Text(
                                    "Find Helpers",
                                    style: _archivoTextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio:
                                          isLargeScreen ? 1.2 : 0.72,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                itemCount: categoryItems.length,
                                itemBuilder: (context, index) {
                                  return HelpersCard(
                                    iconPath:
                                        categoryItems[index]["iconPath"] ?? "",
                                    title: categoryItems[index]["title"] ?? "",
                                    badgeCount: int.parse(
                                      categoryItems[index]["badgeCount"] ?? "0",
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 24),
                              // Emergency Section
                              Text(
                                "Emergency",
                                style: _archivoTextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 16),
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  // Emergency buttons with improved styling
                                  Container(
                                    width: isLargeScreen ? 100.0 : 76.0,
                                    height: isLargeScreen ? 100.0 : 76.0,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.error_outline,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: isLargeScreen ? 100.0 : 76.0,
                                    height: isLargeScreen ? 100.0 : 76.0,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryYellow,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.mail_outline,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              // Announcements Section
                              Text(
                                "Announcements",
                                style: _archivoTextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                height: isLargeScreen ? 130.0 : 160.0,
                                child: Consumer<AnnouncementProvider>(
                                  builder: (context, provider, child) {
                                    final announcements =
                                        provider.announcements;

                                    if (provider.isLoading) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (announcements.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'No announcements available',
                                          style: _archivoTextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    }

                                    return PageView.builder(
                                      controller: _noticePageController,
                                      itemCount: announcements.length,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _currentNoticePage = index;
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        final announcement =
                                            announcements[index];
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
                                                color: Colors.black.withOpacity(
                                                  0.05,
                                                ),
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  if (announcement
                                                      .isImportant) ...[
                                                    const Icon(
                                                      Icons.priority_high,
                                                      color: Colors.red,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 4),
                                                  ],
                                                  Expanded(
                                                    child: Text(
                                                      announcement.title,
                                                      style: _archivoTextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            announcement
                                                                    .isImportant
                                                                ? Colors.red
                                                                : Colors.black,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    announcement.timeAgo,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Expanded(
                                                child: Text(
                                                  announcement.content,
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                builder: (context, provider, _) {
                                  final count = provider.announcements.length;
                                  if (count == 0) return Container();

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      count,
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
                                          width: 8.0,
                                          height: 8.0,
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
                                  );
                                },
                              ),
                              SizedBox(height: 24),
                              // Community Needs Section
                              Text(
                                "Community Needs",
                                style: _archivoTextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.0,
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(color: Colors.grey[200]!),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    // ── First row ──
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start, // align all cards to top
                                      children: [
                                        Expanded(
                                          child: _buildCommunityNeedItem(
                                            icon:
                                                "assets/images/icons/mingcute_service-line.png",
                                            label: "Helpdesk",
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: _buildCommunityNeedItem(
                                            icon:
                                                "assets/images/icons/payment.png",
                                            label: "Society Dues",
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: _buildCommunityNeedItem(
                                            icon:
                                                "assets/images/icons/mynaui_building.png",
                                            label: "Amenities",
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: _buildCommunityNeedItem(
                                            icon:
                                                "assets/images/icons/tachometer-alt-solid.png",
                                            label: "Meter\nConsumption",
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 40),

                                    // ── Second row ──
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start, // and here too
                                      children: [
                                        Expanded(
                                          child: _buildCommunityNeedItem(
                                            icon:
                                                "assets/images/icons/humbleicons_chat.png",
                                            label: "Communication",
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: _buildCommunityNeedItem(
                                            icon:
                                                "assets/images/icons/car.side.arrowtriangle.down.png",
                                            label: "Rental Parking",
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: _buildCommunityNeedItem(
                                            icon:
                                                "assets/images/icons/girl.png",
                                            label: "Daily Help",
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: _buildCommunityNeedItem(
                                            icon: Icons.chevron_right,
                                            label: "View More",
                                            useIconWidget: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24),
                              // Connect with Neighbors Section
                              Row(
                                children: [
                                  Text(
                                    "Connect with Neighbours",
                                    style: _archivoTextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "C-105",
                                    style: _archivoTextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              // Neighbor Cards
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEBB55F),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'DP',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dhruv Patel',
                                            style: _archivoTextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'C-104 (Owner)',
                                            style: _archivoTextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '3 Members',
                                      style: _archivoTextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              // Second Neighbor Card
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEBB55F),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'DP',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dhruv Patel',
                                            style: _archivoTextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'C-104 (Owner)',
                                            style: _archivoTextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '3 Members',
                                      style: _archivoTextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildCommunityNeedItem({
    dynamic icon,
    required String label,
    bool useIconWidget = false,
  }) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child:
                useIconWidget
                    ? Icon(
                      icon as IconData,
                      color: const Color(0xFF777777),
                      size: 24,
                    )
                    : Image.asset(
                      icon as String,
                      width: 24,
                      height: 24,
                      color: const Color(0xFF777777),
                    ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.archivo(
            fontSize: 14.0,
            color: const Color(0xFF777777),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
