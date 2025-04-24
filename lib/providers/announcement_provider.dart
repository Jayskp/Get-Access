import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final bool isImportant;
  final DateTime createdAt;
  final String? category;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.isImportant,
    required this.createdAt,
    this.category = 'Society',
  });

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Handle timestamp from Firestore
    var createdAtTimestamp = data['createdAt'];
    DateTime createdAt;

    if (createdAtTimestamp is Timestamp) {
      createdAt = createdAtTimestamp.toDate();
    } else {
      createdAt = DateTime.now();
    }

    return Announcement(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      content: data['content'] ?? 'No Content',
      imageUrl: data['imageUrl'],
      isImportant: data['isImportant'] ?? data['important'] ?? false,
      createdAt: createdAt,
      category: data['category'] ?? 'Society',
    );
  }

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}m ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class AnnouncementProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Announcement> _announcements = [];
  bool _isLoading = false;

  List<Announcement> get announcements => _announcements;
  bool get isLoading => _isLoading;

  AnnouncementProvider() {
    loadAnnouncements();
  }

  Future<void> loadAnnouncements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot =
          await _firestore
              .collection('announcements')
              .orderBy('createdAt', descending: true)
              .get();

      _announcements =
          querySnapshot.docs
              .map((doc) => Announcement.fromFirestore(doc))
              .toList();
    } catch (e) {
      print('Error loading announcements: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get announcements count
  int get count => _announcements.length;

  // Get important announcements
  List<Announcement> get importantAnnouncements =>
      _announcements.where((a) => a.isImportant).toList();

  // Get regular announcements
  List<Announcement> get regularAnnouncements =>
      _announcements.where((a) => !a.isImportant).toList();
}
