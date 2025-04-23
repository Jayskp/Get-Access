import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_serviices.dart';
import 'util/constants/colors.dart';
import 'announcements_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  bool _loading = false;
  bool _isAdmin = false;
  late TabController _tabController;

  // Controllers for announcement form
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  bool _isImportant = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkAdminStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _checkAdminStatus() async {
    setState(() => _loading = true);

    final isAdmin = await AuthService.isAdmin();

    setState(() {
      _isAdmin = isAdmin;
      _loading = false;
    });

    if (!isAdmin && mounted) {
      // If not admin, redirect to admin login after showing error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You do not have admin privileges'),
          backgroundColor: Colors.red,
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed('/admin_login');
      });
    }
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Admin Dashboard',
            style: _archivoTextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Access Denied',
            style: _archivoTextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'You do not have admin privileges',
                style: _archivoTextStyle(
                  fontSize: 18,
                  color: Colors.grey[600]!,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;
    double horizontalPadding =
        screenWidth > 1024 ? 64 : (screenWidth > 600 ? 40 : 26);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: _archivoTextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
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
                isLargeScreen ? const EdgeInsets.symmetric(vertical: 16) : null,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primaryGreen,
                    unselectedLabelColor: Colors.grey[600],
                    indicatorColor: AppColors.primaryGreen,
                    labelStyle: _archivoTextStyle(fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: 'Posts', icon: Icon(Icons.list)),
                      Tab(text: 'Featured', icon: Icon(Icons.star)),
                      Tab(text: 'Announcements', icon: Icon(Icons.campaign)),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildAllPostsTab(),
                        _buildFeaturedPostsTab(),
                        _buildAnnouncementsTab(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:
          _tabController.index == 2
              ? FloatingActionButton(
                backgroundColor: AppColors.primaryGreen,
                onPressed: () => _showAnnouncementDialog(),
                child: const Icon(Icons.add),
              )
              : null,
    );
  }

  Widget _buildAnnouncementsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('announcements')
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final announcements = snapshot.data?.docs ?? [];

        if (announcements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.campaign_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No announcements yet',
                  style: _archivoTextStyle(
                    fontSize: 18,
                    color: Colors.grey[600]!,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _showAnnouncementDialog(),
                  icon: const Icon(Icons.add),
                  label: Text(
                    'Create Announcement',
                    style: _archivoTextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        // First, filter out important announcements
        final importantAnnouncements =
            announcements
                .where(
                  (doc) =>
                      (doc.data() as Map<String, dynamic>)['important'] == true,
                )
                .toList();

        // Then get regular announcements
        final regularAnnouncements =
            announcements
                .where(
                  (doc) =>
                      (doc.data() as Map<String, dynamic>)['important'] != true,
                )
                .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Manage Announcements',
                    style: _archivoTextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _showAnnouncementDialog(),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(
                      'New',
                      style: _archivoTextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Important announcements section
              if (importantAnnouncements.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.priority_high, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'Important Announcements',
                      style: _archivoTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...importantAnnouncements.map(
                  (announcement) => _buildAnnouncementCard(announcement),
                ),
                const SizedBox(height: 24),
              ],

              // Regular announcements section
              if (regularAnnouncements.isNotEmpty) ...[
                Text(
                  'Regular Announcements',
                  style: _archivoTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...regularAnnouncements.map(
                  (announcement) => _buildAnnouncementCard(announcement),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnnouncementCard(DocumentSnapshot announcement) {
    final data = announcement.data() as Map<String, dynamic>?;
    if (data == null) return const SizedBox.shrink();

    final String title = data['title'] ?? 'No Title';
    final String content = data['content'] ?? 'No Content';
    final bool isImportant = data['isImportant'] ?? false;
    final String? imageUrl = data['imageUrl'];
    final Timestamp? created = data['createdAt'] as Timestamp?;
    final DateTime createdAt = created?.toDate() ?? DateTime.now();
    final String timeAgo = _getTimeAgo(createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isImportant
                ? BorderSide(color: Colors.red.shade800, width: 2)
                : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          _showAnnouncementDialog(
            announcementId: announcement.id,
            title: title,
            content: content,
            imageUrl: imageUrl,
            isImportant: isImportant,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 80,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: _archivoTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                isImportant
                                    ? Colors.red.shade800
                                    : Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isImportant)
                        Icon(
                          Icons.priority_high,
                          color: Colors.red.shade800,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 60),
                    child: Text(
                      content,
                      style: _archivoTextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeAgo,
                        style: _archivoTextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              _showAnnouncementDialog(
                                announcementId: announcement.id,
                                title: title,
                                content: content,
                                imageUrl: imageUrl,
                                isImportant: isImportant,
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              _showDeleteConfirmation(announcement.id);
                            },
                          ),
                        ],
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
  }

  void _showAnnouncementDialog({
    String? announcementId,
    String? title,
    String? content,
    String? imageUrl,
    bool isImportant = false,
  }) {
    // If editing an existing announcement, pre-populate the form
    if (announcementId != null) {
      _titleController.text = title ?? '';
      _contentController.text = content ?? '';
      _imageUrlController.text = imageUrl ?? '';
      _isImportant = isImportant;
    } else {
      // Clear form for new announcement
      _titleController.clear();
      _contentController.clear();
      _imageUrlController.clear();
      _isImportant = false;
    }

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      announcementId != null
                          ? 'Edit Announcement'
                          : 'Create Announcement',
                      style: _archivoTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter announcement title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        hintText: 'Enter announcement content',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: 'Image URL (optional)',
                        hintText: 'Enter image URL',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _isImportant,
                          activeColor: Colors.red,
                          onChanged: (value) {
                            setState(() {
                              _isImportant = value ?? false;
                            });
                            Navigator.of(context).pop();
                            _showAnnouncementDialog(
                              announcementId: announcementId,
                              title: _titleController.text,
                              content: _contentController.text,
                              imageUrl: _imageUrlController.text,
                              isImportant: value ?? false,
                            );
                          },
                        ),
                        const Text('Mark as important'),
                        if (_isImportant) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.priority_high,
                            size: 16,
                            color: Colors.red,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel', style: _archivoTextStyle()),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (_titleController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Title cannot be empty'),
                                ),
                              );
                              return;
                            }

                            if (announcementId != null) {
                              _updateAnnouncement(announcementId);
                            } else {
                              _createAnnouncement();
                            }

                            Navigator.pop(context);
                          },
                          child: Text(
                            announcementId != null ? 'Update' : 'Create',
                            style: _archivoTextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';

    if (timestamp is Timestamp) {
      final dateTime = timestamp.toDate();
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    return 'Unknown date';
  }

  Future<void> _createAnnouncement() async {
    setState(() => _loading = true);

    try {
      await FirebaseFirestore.instance.collection('announcements').add({
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'imageUrl': _imageUrlController.text.trim(),
        'important': _isImportant,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy':
            (await AuthService.getCurrentUser())['userId'] ?? 'unknown',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Announcement created successfully'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating announcement: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _updateAnnouncement(String announcementId) async {
    setState(() => _loading = true);

    try {
      await FirebaseFirestore.instance
          .collection('announcements')
          .doc(announcementId)
          .update({
            'title': _titleController.text.trim(),
            'content': _contentController.text.trim(),
            'imageUrl': _imageUrlController.text.trim(),
            'important': _isImportant,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Announcement updated successfully'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating announcement: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _deleteAnnouncement(String announcementId) async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Delete Announcement',
              style: _archivoTextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Are you sure you want to delete this announcement? This action cannot be undone.',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: _archivoTextStyle()),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() => _loading = true);

                  try {
                    await FirebaseFirestore.instance
                        .collection('announcements')
                        .doc(announcementId)
                        .delete();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 8),
                            const Text('Announcement deleted successfully'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting announcement: $e'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  } finally {
                    setState(() => _loading = false);
                  }
                },
                child: Text(
                  'Delete',
                  style: _archivoTextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildAllPostsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('posts')
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data?.docs ?? [];

        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.post_add, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No posts available',
                  style: _archivoTextStyle(
                    fontSize: 18,
                    color: Colors.grey[600]!,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'All Posts',
                style: _archivoTextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  final postData = post.data() as Map<String, dynamic>;
                  final postId = post.id;
                  final isFeatured = postData['featured'] ?? false;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                    elevation: isFeatured ? 2 : 1,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _showPostDetails(post),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (postData['imageUrl'] != null &&
                                postData['imageUrl'].toString().isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  postData['imageUrl'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (ctx, _, __) => Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          postData['title'] ?? 'No Title',
                                          style: _archivoTextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (isFeatured)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.shade100,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                size: 14,
                                                color: Colors.amber,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Featured',
                                                style: _archivoTextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.amber[800]!,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    postData['description'] ?? 'No description',
                                    style: _archivoTextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'By: ${postData['authorName'] ?? 'Unknown'}',
                                        style: _archivoTextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]!,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.comment,
                                        size: 12,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${postData['comments'] ?? 0}',
                                        style: _archivoTextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]!,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.favorite,
                                        size: 12,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${postData['likes'] ?? 0}',
                                        style: _archivoTextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]!,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: Icon(
                                          isFeatured
                                              ? Icons.star
                                              : Icons.star_border,
                                          color:
                                              isFeatured
                                                  ? Colors.amber
                                                  : Colors.grey[400],
                                          size: 20,
                                        ),
                                        onPressed:
                                            () => _toggleFeaturePost(
                                              postId,
                                              !isFeatured,
                                            ),
                                        tooltip:
                                            isFeatured
                                                ? 'Unfeature'
                                                : 'Feature',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red[400],
                                          size: 20,
                                        ),
                                        onPressed:
                                            () =>
                                                _showDeleteConfirmation(postId),
                                        tooltip: 'Delete',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeaturedPostsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('posts')
              .where('featured', isEqualTo: true)
              .orderBy('featuredAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data?.docs ?? [];

        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No featured posts yet',
                  style: _archivoTextStyle(
                    fontSize: 18,
                    color: Colors.grey[600]!,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Feature posts from the "All Posts" tab',
                  style: _archivoTextStyle(
                    fontSize: 14,
                    color: Colors.grey[500]!,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber[700], size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Featured Posts',
                    style: _archivoTextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  final postData = post.data() as Map<String, dynamic>;
                  final postId = post.id;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.amber.shade200, width: 1),
                    ),
                    elevation: 2,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _showPostDetails(post),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (postData['imageUrl'] != null &&
                                postData['imageUrl'].toString().isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  postData['imageUrl'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (ctx, _, __) => Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          postData['title'] ?? 'No Title',
                                          style: _archivoTextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade100,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 14,
                                              color: Colors.amber,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Featured',
                                              style: _archivoTextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber[800]!,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    postData['description'] ?? 'No description',
                                    style: _archivoTextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'By: ${postData['authorName'] ?? 'Unknown'}',
                                        style: _archivoTextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]!,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.comment,
                                        size: 12,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${postData['comments'] ?? 0}',
                                        style: _archivoTextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]!,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.favorite,
                                        size: 12,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${postData['likes'] ?? 0}',
                                        style: _archivoTextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]!,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        onPressed:
                                            () => _toggleFeaturePost(
                                              postId,
                                              false,
                                            ),
                                        tooltip: 'Unfeature',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 16),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red[400],
                                          size: 20,
                                        ),
                                        onPressed:
                                            () =>
                                                _showDeleteConfirmation(postId),
                                        tooltip: 'Delete',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPostDetails(DocumentSnapshot post) {
    final postData = post.data() as Map<String, dynamic>;
    final isFeatured = postData['featured'] ?? false;

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (postData['imageUrl'] != null &&
                      postData['imageUrl'].toString().isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        postData['imageUrl'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (ctx, _, __) => Container(
                              height: 100,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                postData['title'] ?? 'No Title',
                                style: _archivoTextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isFeatured)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Featured',
                                      style: _archivoTextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          postData['description'] ?? 'No description',
                          style: _archivoTextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Created by: ${postData['authorName'] ?? 'Unknown'}',
                              style: _archivoTextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (postData['createdAt'] != null)
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Posted on: ${_formatTimestamp(postData['createdAt'])}',
                                style: _archivoTextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Close', style: _archivoTextStyle()),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isFeatured
                                        ? Colors.grey.shade200
                                        : AppColors.primaryGreen,
                                foregroundColor:
                                    isFeatured ? Colors.black87 : Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _toggleFeaturePost(post.id, !isFeatured);
                              },
                              icon: Icon(
                                isFeatured ? Icons.star_border : Icons.star,
                                size: 18,
                              ),
                              label: Text(isFeatured ? 'Unfeature' : 'Feature'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _toggleFeaturePost(String postId, bool featured) async {
    try {
      setState(() => _loading = true);

      final result = await AuthService.toggleFeaturePost(postId, featured);

      setState(() => _loading = false);

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  featured
                      ? 'Post featured successfully'
                      : 'Post unfeatured successfully',
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to update post'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _showDeleteConfirmation(String postId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Delete Post',
              style: _archivoTextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Are you sure you want to delete this post? This action cannot be undone.',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel', style: _archivoTextStyle()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deletePost(postId);
                },
                child: Text(
                  'Delete',
                  style: _archivoTextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _deletePost(String postId) async {
    try {
      setState(() => _loading = true);

      final result = await AuthService.deletePost(postId);

      setState(() => _loading = false);

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Post deleted successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to delete post'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
