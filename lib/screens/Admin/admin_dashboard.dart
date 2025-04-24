import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getaccess/screens/Admin/manage_notices.dart';
import 'package:getaccess/screens/Admin/manage_announcements.dart';
import 'package:getaccess/screens/Admin/manage_posts.dart';
// TODO: Create ManageUsersScreen
// import 'package:getaccess/screens/Admin/manage_users.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Theme colors
  static const Color primaryColor = Color(0xFF004D40);
  static const Color accentColor = Color(0xFF26A69A);
  static const Color adminColor = Colors.redAccent;
  static const Color lightGrey = Color(0xFFF7F7F7);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Admin Dashboard',
          style: _archivoTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: adminColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'ADMIN',
                  style: _archivoTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverviewSection(),
              SizedBox(height: 24),
              _buildSectionTitle('Content Management'),
              SizedBox(height: 16),
              _buildAdminGridSection(),
              SizedBox(height: 24),
              _buildSectionTitle('Recent Activity'),
              SizedBox(height: 16),
              _buildRecentActivityList(),
              SizedBox(height: 24),
              _buildSectionTitle('Quick Actions'),
              SizedBox(height: 16),
              _buildQuickActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: _archivoTextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: adminColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: adminColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.admin_panel_settings, color: adminColor, size: 24),
              SizedBox(width: 12),
              Text(
                'Admin Overview',
                style: _archivoTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: adminColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Users', '142', Icons.people_outline),
              _buildStatCard('Posts', '87', Icons.post_add_outlined),
              _buildStatCard('Notices', '12', Icons.announcement_outlined),
              _buildStatCard('Reports', '6', Icons.flag_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: Icon(icon, color: adminColor, size: 24)),
        ),
        SizedBox(height: 8),
        Text(
          count,
          style: _archivoTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: _archivoTextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildAdminGridSection() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildAdminGridItem(
          'Manage Notices',
          Icons.announcement_outlined,
          Colors.blue,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManageNoticesScreen()),
          ),
        ),
        _buildAdminGridItem(
          'Manage Announcements',
          Icons.campaign_outlined,
          Colors.orange,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManageAnnouncementsScreen(),
            ),
          ),
        ),
        _buildAdminGridItem(
          'Manage Posts',
          Icons.post_add_outlined,
          Colors.green,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManagePostsScreen()),
          ),
        ),
        _buildAdminGridItem(
          'Manage Users',
          Icons.people_outline,
          Colors.purple,
          () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User management coming soon')),
          ),
        ),
      ],
    );
  }

  Widget _buildAdminGridItem(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(child: Icon(icon, size: 30, color: color)),
            ),
            SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: _archivoTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList() {
    final activities = [
      {
        'title': 'Notice Published',
        'description': 'Water Supply Interruption notice published',
        'time': '10 minutes ago',
        'icon': Icons.announcement_outlined,
        'color': Colors.blue,
      },
      {
        'title': 'User Reported',
        'description': 'Post #1234 reported for inappropriate content',
        'time': '2 hours ago',
        'icon': Icons.flag_outlined,
        'color': Colors.red,
      },
      {
        'title': 'Announcement Posted',
        'description': 'Society Meeting announcement created',
        'time': '3 hours ago',
        'icon': Icons.campaign_outlined,
        'color': Colors.orange,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: activities.length,
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: (activity['color'] as Color).withOpacity(0.2),
              child: Icon(
                activity['icon'] as IconData,
                color: activity['color'] as Color,
                size: 20,
              ),
            ),
            title: Text(
              activity['title'] as String,
              style: _archivoTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  activity['description'] as String,
                  style: _archivoTextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  activity['time'] as String,
                  style: _archivoTextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildQuickActionButton(
          'Add Notice',
          Icons.add_alert_outlined,
          Colors.blue,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManageNoticesScreen(createNew: true),
            ),
          ),
        ),
        _buildQuickActionButton(
          'Add Announcement',
          Icons.campaign_outlined,
          Colors.orange,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManageAnnouncementsScreen(createNew: true),
            ),
          ),
        ),
        _buildQuickActionButton(
          'Approve Reports',
          Icons.report_outlined,
          Colors.red,
          () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reports feature coming soon')),
          ),
        ),
        _buildQuickActionButton(
          'User Access',
          Icons.privacy_tip_outlined,
          Colors.purple,
          () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User access management coming soon')),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Center(child: Icon(icon, color: color, size: 24)),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 70,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: _archivoTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
