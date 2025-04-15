import 'package:flutter/material.dart';
import 'package:getaccess/Search.dart';
import 'package:getaccess/util/constants/colors.dart';
import 'package:getaccess/widgets/helpers_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

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

  void initState() {
    super.initState();
    // Listen for search text changes

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 26, right: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Community",
                      style: _archivoTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search_rounded, size: 24),
                    ),
                    SizedBox(width: 19),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPage()),
                        );
                      },
                      icon: Image(
                        image: AssetImage("assets/images/icons/bx-chat.png"),
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
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
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(27),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.pets, color: Colors.grey, size: 24),
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
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Connect",
                  style: _archivoTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(23),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Resident Directory",
                                  style: _archivoTextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
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
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Image(
                          image: AssetImage("assets/images/icons/Group 56.png"),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "+350",
                          style: _archivoTextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Find Helpers",
                      style: _archivoTextStyle(
                        fontSize: 18,
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
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: categoryItems.length,
                  itemBuilder: (context, index) {
                    return HelpersCard(
                      iconPath: categoryItems[index]["iconPath"] ?? "",
                      title: categoryItems[index]["title"] ?? "",
                      badgeCount: int.parse(
                        categoryItems[index]["badgeCount"] ?? "0",
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Image(image: AssetImage("assets/images/cook.png")),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cook",
                                  style: _archivoTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Ketki",
                                  style: _archivoTextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 23),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 9,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 9,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 9,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "4.5",
                                  style: _archivoTextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 17),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Image(image: AssetImage("assets/images/cook.png")),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cook",
                                  style: _archivoTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Ketki",
                                  style: _archivoTextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 13),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 9,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 9,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 9,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "4.5",
                                  style: _archivoTextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Emergency",
                  style: _archivoTextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    // 1st icon
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.error_outline,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // 2nd icon
                    Container(
                      width: 76,
                      height: 76,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryYellow,
                        shape: BoxShape.circle,
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
                Text(
                  "Announcements",
                  style: _archivoTextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 120,
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
                                Text(
                                  notice['title'],
                                  style: _archivoTextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '${notice['timeAgo']}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notice['content'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
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
                SizedBox(height: 20),
                Text(
                  "Community Needs",
                  style: _archivoTextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(29),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                          "assets/images/icons/mingcute_service-line.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "Help Desk",
                                  style: _archivoTextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                          "assets/images/icons/payment.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "Society Dues",
                                  style: _archivoTextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                          "assets/images/icons/mynaui_building.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "Amenities",
                                  style: _archivoTextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                          "assets/images/icons/tachometer-alt-solid.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "Meter Consumption",
                                  style: _archivoTextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                          "assets/images/icons/humbleicons_chat.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "Communications",
                                  style: _archivoTextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                          "assets/images/icons/car.side.arrowtriangle.down.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "Rental Parking",
                                  style: _archivoTextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Image(
                                        image: AssetImage(
                                          "assets/images/icons/girl.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "Daily Help",
                                  style: _archivoTextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  "Help Desk",
                                  style: _archivoTextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Connect with Neighbours",
                      style: _archivoTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("C-105",style: _archivoTextStyle(
                      color:Colors.grey
                    ),)
                  ],
                ),
                SizedBox(height:16,),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFEBB55F),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'DP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dhruv Patel',
                              style:_archivoTextStyle(

                              )
                            ),
                            Text(
                              'C-104 (Owner)',
                              style: _archivoTextStyle(
                                color:Colors.grey
                              )
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '3 Members',
                        style: _archivoTextStyle()
                      ),
                    ],
                  ),
                ),
                SizedBox(height:16,),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFEBB55F),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'DP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Dhruv Patel',
                                style:_archivoTextStyle(

                                )
                            ),
                            Text(
                                'C-104 (Owner)',
                                style: _archivoTextStyle(
                                    color:Colors.grey
                                )
                            ),
                          ],
                        ),
                      ),
                      Text(
                          '3 Members',
                          style: _archivoTextStyle()
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
