import 'package:flutter/material.dart';
import 'package:getaccess/SearchDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Map<String, dynamic> settingsData = {
    "user": {"avatarText": "D", "name": "Dhruv Patel", "id": "ID-154689"},
    "profileIncompleteText":
        "Your Profile is Incomplete... please complete it!!!",
    "membersSectionTitle": "Members",
    "membersGrid": [
      {
        "title": "Add Family Members",
        "icon": "assets/images/icons/Circularplus.png",
      },
      {"title": "Add Pets", "icon": "assets/images/icons/Circularplus.png"},
      {"title": "House Help", "icon": "assets/images/icons/Circularplus.png"},
      {"title": "Vehicle", "icon": "assets/images/icons/Circularplus.png"},
    ],
    "address": {
      "label": "My Address",
      "details": "A-105, Sahaj Flats, Opp Arush Icon, Radhanpur Road",
      "shareIcon": "assets/images/icons/Share.png",
    },
    "sections": [
      {
        "sectionTitle": "Security & Notification",
        "items": [
          {
            "title": "Notification Preferences",
            "icon": "assets/images/icons/notifications.png",
          },
          {"title": "Security Alert", "icon": "assets/images/icons/alert.png"},
        ],
      },
      {
        "sectionTitle": "Purchases",
        "items": [
          {"title": "My Orders", "icon": "assets/images/icons/shippingbox.png"},
          {"title": "My Plans", "icon": "assets/images/icons/crown.png"},
        ],
      },
    ],
    "manageFlats": {
      "sectionTitle": "Manage Flats",
      "flatName": "Sahaj Flats, C-105",
      "status": "Active",
      "icon": "assets/images/icons/home.png",
      "addFlatText": "Add Flat/Home/Villa",
    },
    "generalSettings": {
      "sectionTitle": "General Settings",
      "items": [
        {
          "title": "Support & Feedback",
          "icon": "assets/images/icons/like-shapes.png",
        },
        {"title": "Share App", "icon": "assets/images/icons/share-all.png"},
        {"title": "Account Info", "icon": "assets/images/icons/account.png"},
        {"title": "Logout", "icon": "assets/images/icons/logout.png"},
      ],
    },
  };

  final Color _dividerColor = const Color(0xFFE0E0E0);
  final Color _lightGreyColor = const Color(0xFFF7F7F7);
  final Color _incompleteProfileBgColor = const Color(0xFFEEEEEE);
  final Color _greenBorderColor = Colors.green;
  final Color _activeChipColor = const Color(0xFF4CAF50);

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
    final userData = settingsData["user"];
    final incompleteProfileText = settingsData["profileIncompleteText"];
    final membersSectionTitle = settingsData["membersSectionTitle"];
    final membersGrid = settingsData["membersGrid"] as List;
    final addressData = settingsData["address"];
    final sectionsData = settingsData["sections"] as List;
    final manageFlatsData = settingsData["manageFlats"];
    final generalSettingsData = settingsData["generalSettings"];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      "assets/images/icons/backarrow.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Settings",
                      style: _archivoTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchDetailsPage(),
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/images/icons/search.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: _dividerColor),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Color(0xFFD6C104),
                          child: Text(
                            userData["avatarText"],
                            style: _archivoTextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData["name"],
                                style: _archivoTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userData["id"],
                                style: _archivoTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset(
                            "assets/images/icons/qrcode.png",
                            width: 36,
                            height: 36,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _incompleteProfileBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              incompleteProfileText,
                              style: _archivoTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey.shade700,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      membersSectionTitle,
                      style: _archivoTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      itemCount: membersGrid.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 60,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemBuilder: (context, index) {
                        final item = membersGrid[index];
                        return _MemberButton(
                          iconPath: item["icon"],
                          text: item["title"],
                          greenBorderColor: _greenBorderColor,
                          textStyle: _archivoTextStyle(fontSize: 14),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildAddressSection(addressData),
                    const SizedBox(height: 24),
                    for (var section in sectionsData) ...[
                      _buildSectionWithListTiles(section),
                      const SizedBox(height: 24),
                    ],
                    _buildManageFlats(manageFlatsData),
                    const SizedBox(height: 24),
                    _buildGeneralSettings(generalSettingsData),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection(Map<String, dynamic> addressData) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addressData["label"],
                  style: _archivoTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  addressData["details"],
                  style: _archivoTextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Image.asset(addressData["shareIcon"], width: 24, height: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWithListTiles(Map<String, dynamic> sectionData) {
    final String sectionTitle = sectionData["sectionTitle"];
    final List items = sectionData["items"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: _archivoTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: _lightGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children:
                items.map((item) {
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Row(
                        children: [
                          Image.asset(item["icon"], width: 24, height: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item["title"],
                              style: _archivoTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey.shade700,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildManageFlats(Map<String, dynamic> manageData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          manageData["sectionTitle"],
          style: _archivoTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _lightGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Image.asset(manageData["icon"], width: 24, height: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  manageData["flatName"],
                  style: _archivoTextStyle(fontSize: 14),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _activeChipColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  manageData["status"],
                  style: _archivoTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _lightGreyColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.add_home_work_outlined, color: Colors.grey.shade800),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    manageData["addFlatText"],
                    style: _archivoTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade700),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralSettings(Map<String, dynamic> generalSettingsData) {
    final String sectionTitle = generalSettingsData["sectionTitle"];
    final List items = generalSettingsData["items"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: _archivoTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 60,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: _lightGreyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Image.asset(item["icon"], width: 24, height: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item["title"],
                        style: _archivoTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey.shade700),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MemberButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final Color greenBorderColor;
  final TextStyle textStyle;

  const _MemberButton({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.greenBorderColor,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: DottedBorder(
        color: greenBorderColor,
        strokeWidth: 2,
        dashPattern: const [6, 3],
        borderType: BorderType.RRect,
        radius: const Radius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Center(child: Image.asset(iconPath, width: 31, height: 31)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
