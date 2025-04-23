import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Announcements & Notices',
          style: GoogleFonts.archivo(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                    style: GoogleFonts.archivo(
                      fontSize: 18,
                      color: Colors.grey[600],
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
                        (doc.data() as Map<String, dynamic>)['important'] ==
                        true,
                  )
                  .toList();

          // Then get regular announcements
          final regularAnnouncements =
              announcements
                  .where(
                    (doc) =>
                        (doc.data() as Map<String, dynamic>)['important'] !=
                        true,
                  )
                  .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Important announcements section
                if (importantAnnouncements.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.priority_high, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Important Announcements',
                        style: GoogleFonts.archivo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: importantAnnouncements.length,
                    itemBuilder: (context, index) {
                      return _buildAnnouncementCard(
                        context,
                        importantAnnouncements[index],
                        isImportant: true,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],

                // Regular announcements section
                if (regularAnnouncements.isNotEmpty) ...[
                  Text(
                    'Announcements',
                    style: GoogleFonts.archivo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: regularAnnouncements.length,
                    itemBuilder: (context, index) {
                      return _buildAnnouncementCard(
                        context,
                        regularAnnouncements[index],
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnnouncementCard(
    BuildContext context,
    DocumentSnapshot document, {
    bool isImportant = false,
  }) {
    final data = document.data() as Map<String, dynamic>;
    final hasImage =
        data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isImportant ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isImportant
                ? const BorderSide(color: Colors.red, width: 1.5)
                : BorderSide.none,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                data['imageUrl'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 100,
                      color: Colors.grey[300],
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
                        data['title'] ?? 'Untitled',
                        style: GoogleFonts.archivo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isImportant ? Colors.red[800] : Colors.black87,
                        ),
                      ),
                    ),
                    if (isImportant)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.priority_high,
                              size: 14,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Important',
                              style: GoogleFonts.archivo(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data['content'] ?? 'No content',
                  style: GoogleFonts.archivo(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                if (data['createdAt'] != null)
                  Text(
                    'Posted on: ${_formatTimestamp(data['createdAt'])}',
                    style: GoogleFonts.archivo(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
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
}
