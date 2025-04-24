import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:getaccess/auth_serviices.dart';

class ManagePostsScreen extends StatefulWidget {
  final bool createNew;

  const ManagePostsScreen({super.key, this.createNew = false});

  @override
  _ManagePostsScreenState createState() => _ManagePostsScreenState();
}

class _ManagePostsScreenState extends State<ManagePostsScreen> {
  List<Map<String, dynamic>> posts = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPosts();
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
      letterSpacing: 0.2,
    );
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final snapshot =
          await FirebaseDatabase.instance.ref().child('Posts').once();
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final loadedPosts = <Map<String, dynamic>>[];

        data.forEach((key, value) {
          final postData = Map<String, dynamic>.from(value as Map);
          postData['id'] = key;
          loadedPosts.add(postData);
        });

        // Sort posts by creation time (newest first)
        loadedPosts.sort((a, b) {
          final DateTime dateA = DateTime.parse(
            a['createdAt'] ?? DateTime.now().toString(),
          );
          final DateTime dateB = DateTime.parse(
            b['createdAt'] ?? DateTime.now().toString(),
          );
          return dateB.compareTo(dateA);
        });

        setState(() {
          posts = loadedPosts;
          _isLoading = false;
        });
      } else {
        setState(() {
          posts = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load posts: $e';
      });
      debugPrint('Error loading posts: $e');
    }
  }

  void _deletePost(String id) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text('Delete Post'),
            content: Text('Are you sure you want to delete this post?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);

                  setState(() => _isLoading = true);

                  try {
                    final success = await AuthService.deletePost(id);

                    if (!mounted) return;

                    setState(() => _isLoading = false);

                    if (success) {
                      setState(() {
                        posts.removeWhere((post) => post['id'] == id);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Post deleted successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to delete post'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    if (!mounted) return;

                    setState(() => _isLoading = false);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting post: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _toggleFeaturedStatus(String id, bool currentStatus) async {
    try {
      final success = await AuthService.toggleFeaturePost(id, !currentStatus);

      if (!mounted) return;

      if (success) {
        _loadPosts(); // Refresh posts to show updated status

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentStatus
                  ? 'Post unfeatured successfully'
                  : 'Post featured successfully',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update featured status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating featured status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Manage Posts',
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
              color: Colors.red,
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
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _hasError
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red.shade300,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Error loading posts',
                        style: _archivoTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: _archivoTextStyle(color: Colors.grey.shade600),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPosts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          'Retry',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
                : posts.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.post_add,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No posts yet',
                        style: _archivoTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'When users create posts, they will appear here',
                        textAlign: TextAlign.center,
                        style: _archivoTextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
                : RefreshIndicator(
                  onRefresh: _loadPosts,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: posts.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return _buildPostCard(post);
                    },
                  ),
                ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final String postId = post['id'] ?? '';
    final String authorName = post['authorName'] ?? 'Unknown User';
    final String authorBlock = post['authorBlock'] ?? '';
    final String content = post['content'] ?? '';
    final bool isFeatured = post['isFeatured'] ?? false;
    final int likes = post['likes'] ?? 0;
    final int comments = post['comments'] ?? 0;

    // Parse the creation date
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(
        post['createdAt'] ?? DateTime.now().toString(),
      );
    } catch (e) {
      createdAt = DateTime.now();
    }

    final String formattedDate = DateFormat(
      'MMM d, yyyy • h:mm a',
    ).format(createdAt);

    return Container(
      decoration: BoxDecoration(
        color: isFeatured ? Colors.amber.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFeatured ? Colors.amber.shade300 : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isFeatured ? Colors.amber.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName,
                        style: _archivoTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (authorBlock.isNotEmpty)
                        Text(
                          authorBlock,
                          style: _archivoTextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isFeatured)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Featured',
                      style: _archivoTextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: _archivoTextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style: _archivoTextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 16,
                          color: Colors.red.shade300,
                        ),
                        SizedBox(width: 4),
                        Text(
                          likes.toString(),
                          style: _archivoTextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 16,
                          color: Colors.blue.shade300,
                        ),
                        SizedBox(width: 4),
                        Text(
                          comments.toString(),
                          style: _archivoTextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Toggle featured status
                TextButton.icon(
                  onPressed: () => _toggleFeaturedStatus(postId, isFeatured),
                  icon: Icon(
                    isFeatured ? Icons.star : Icons.star_border,
                    color: isFeatured ? Colors.amber : Colors.grey,
                    size: 24,
                  ),
                  label: Text(
                    isFeatured ? 'Featured' : 'Feature',
                    style: _archivoTextStyle(
                      color: isFeatured ? Colors.amber : Colors.grey,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _deletePost(postId),
                  icon: Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
