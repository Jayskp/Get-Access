import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'pinned': isPinned,
      'createdAt': Timestamp.fromDate(createdAt),
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

  List<Notice> get notices => _notices;
  List<Notice> get pinnedNotices => _notices.where((n) => n.isPinned).toList();
  List<Notice> get regularNotices =>
      _notices.where((n) => !n.isPinned).toList();
  bool get isLoading => _isLoading;

  Future<void> loadNotices() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('notices')
              .orderBy('createdAt', descending: true)
              .get();

      _notices =
          snapshot.docs
              .map((doc) => Notice.fromMap(doc.data(), doc.id))
              .toList();
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
        id: '', // Temporary ID, will be replaced with Firestore ID
        title: title,
        content: content,
        isPinned: isPinned,
        createdAt: DateTime.now(),
      );

      final docRef = await FirebaseFirestore.instance
          .collection('notices')
          .add(notice.toMap());

      final newNotice = Notice(
        id: docRef.id,
        title: title,
        content: content,
        isPinned: isPinned,
        createdAt: DateTime.now(),
      );

      _notices.insert(0, newNotice); // Add to the beginning of the list
      notifyListeners(); // Make sure this is called
      return docRef.id;
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
      await FirebaseFirestore.instance.collection('notices').doc(id).update({
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
      await FirebaseFirestore.instance.collection('notices').doc(id).delete();

      _notices.removeWhere((n) => n.id == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting notice: $e");
    }
  }
}
