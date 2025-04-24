import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';

class Notice {
  final String id;
  final String title;
  final String content;
  final bool isPinned;
  final DateTime createdAt;
  String get timeAgo => _getTimeAgo(createdAt);

  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.isPinned,
    required this.createdAt,
  });

  factory Notice.fromMap(Map<String, dynamic> data, String id) {
    return Notice(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      isPinned: data['pinned'] ?? false,
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'pinned': isPinned,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

class NoticeProvider with ChangeNotifier {
  List<Notice> _notices = [];
  bool _isLoading = false;
  final DatabaseReference _noticesRef = FirebaseDatabase.instance.ref().child('notices');

  List<Notice> get notices => _notices;
  List<Notice> get pinnedNotices => _notices.where((n) => n.isPinned).toList();
  List<Notice> get regularNotices => _notices.where((n) => !n.isPinned).toList();
  bool get isLoading => _isLoading;

  Future<void> loadNotices() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _noticesRef.get();

      if (snapshot.exists) {
        _notices = [];
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          _notices.add(Notice.fromMap(Map<String, dynamic>.from(value), key));
        });

        // Sort by createdAt, descending order (newest first)
        _notices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        _notices = [];
      }
    } catch (e) {
      print("Error loading notices: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> addNotice(String title, String content, bool isPinned) async {
    try {
      final notice = Notice(
        id: '', // Temporary ID, will be replaced with database key
        title: title,
        content: content,
        isPinned: isPinned,
        createdAt: DateTime.now(),
      );

      // Generate a new key
      final newNoticeRef = _noticesRef.push();
      await newNoticeRef.set(notice.toMap());
      String newId = newNoticeRef.key!;

      final newNotice = Notice(
        id: newId,
        title: title,
        content: content,
        isPinned: isPinned,
        createdAt: DateTime.now(),
      );

      _notices.insert(0, newNotice); // Add to the beginning of the list
      notifyListeners();
      return newId;
    } catch (e) {
      print("Error adding notice: $e");
      return '';
    }
  }

  Future<void> updateNotice(
      String id,
      String title,
      String content,
      bool isPinned,
      ) async {
    try {
      await _noticesRef.child(id).update({
        'title': title,
        'content': content,
        'pinned': isPinned,
      });

      final index = _notices.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notices[index] = Notice(
          id: id,
          title: title,
          content: content,
          isPinned: isPinned,
          createdAt: _notices[index].createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      print("Error updating notice: $e");
    }
  }

  Future<void> deleteNotice(String id) async {
    try {
      await _noticesRef.child(id).remove();

      _notices.removeWhere((n) => n.id == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting notice: $e");
    }
  }
}