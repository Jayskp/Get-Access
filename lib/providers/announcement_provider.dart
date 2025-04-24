import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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

  factory Announcement.fromRTDB(Map<dynamic, dynamic> data, String id) {
    // Convert timestamp from milliseconds since epoch to DateTime
    DateTime createdAt;
    try {
      if (data['createdAt'] is int) {
        createdAt = DateTime.fromMillisecondsSinceEpoch(data['createdAt']);
      } else {
        createdAt = DateTime.now();
      }
    } catch (e) {
      createdAt = DateTime.now();
    }

    return Announcement(
      id: id,
      title: data['title'] ?? 'No Title',
      content: data['content'] ?? 'No Content',
      imageUrl: data['imageUrl'],
      isImportant: data['isImportant'] ?? data['important'] ?? false,
      createdAt: createdAt,
      category: data['category'] ?? 'Society',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'isImportant': isImportant,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'category': category,
    };
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

class AnnouncementProvider with ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child(
    'announcements',
  );
  List<Announcement> _announcements = [];
  bool _isLoading = false;

  List<Announcement> get announcements => _announcements;
  bool get isLoading => _isLoading;

  AnnouncementProvider() {
    loadAnnouncements();
    // Listen for real-time updates
    _setupRealtimeListener();
  }

  void _setupRealtimeListener() {
    _dbRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _loadFromSnapshot(event.snapshot);
      }
    });
  }

  void _loadFromSnapshot(DataSnapshot snapshot) {
    _announcements = [];
    final data = snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      data.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          _announcements.add(Announcement.fromRTDB(value, key));
        }
      });

      // Sort by date
      _announcements.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    }
  }

  Future<void> loadAnnouncements() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _dbRef.get();
      if (snapshot.value != null) {
        _loadFromSnapshot(snapshot);
      }
    } catch (e) {
      print("Error loading announcements: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> addAnnouncement(
    String title,
    String content,
    bool isImportant,
  ) async {
    try {
      // Create a new announcement
      final newAnnouncement = Announcement(
        id: '',
        title: title,
        content: content,
        isImportant: isImportant,
        createdAt: DateTime.now(),
      );

      // Push to Realtime Database and get the key
      final newRef = _dbRef.push();
      await newRef.set(newAnnouncement.toJson());

      // No need to update local list as the listener will do it
      return newRef.key ?? '';
    } catch (e) {
      print("Error adding announcement: $e");
      return '';
    }
  }

  Future<void> updateAnnouncement(
    String id,
    String title,
    String content,
    bool isImportant,
  ) async {
    try {
      await _dbRef.child(id).update({
        'title': title,
        'content': content,
        'isImportant': isImportant,
        'lastUpdated': DateTime.now().millisecondsSinceEpoch,
      });

      // The listener will update the local list
    } catch (e) {
      print("Error updating announcement: $e");
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    try {
      await _dbRef.child(id).remove();
      // The listener will update the local list
    } catch (e) {
      print("Error deleting announcement: $e");
    }
  }

  // Get important announcements
  List<Announcement> get importantAnnouncements =>
      _announcements.where((a) => a.isImportant).toList();

  // Get regular announcements
  List<Announcement> get regularAnnouncements =>
      _announcements.where((a) => !a.isImportant).toList();
}
