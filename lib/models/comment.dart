import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Comment {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String authorBlock;
  final String? authorAvatarUrl;
  final String content;
  final DateTime createdAt;
  int likes;
  List<String> likedBy;
  bool isLiked;

  Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.authorBlock,
    this.authorAvatarUrl,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.likedBy = const [],
    this.isLiked = false,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  factory Comment.create({
    required String postId,
    required String authorName,
    required String authorBlock,
    String? authorAvatarUrl,
    required String content,
  }) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    // Ensure author name is never empty
    final String safeName = authorName.isNotEmpty ? authorName : 'Anonymous';

    return Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: postId,
      authorId: userId,
      authorName: safeName,
      authorBlock: authorBlock,
      authorAvatarUrl: authorAvatarUrl,
      content: content,
      createdAt: DateTime.now(),
    );
  }

  void toggleLike(String userId) {
    if (likedBy.contains(userId)) {
      likes--;
      likedBy.remove(userId);
      isLiked = false;
    } else {
      likes++;
      likedBy.add(userId);
      isLiked = true;
    }
  }

  // For Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'authorBlock': authorBlock,
      'authorAvatarUrl': authorAvatarUrl,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likes': likes,
      'likedBy': likedBy,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map, String currentUserId) {
    // Ensure all required fields have default values if missing or invalid
    final String safeAuthorName =
        (map['authorName'] is String &&
                (map['authorName'] as String).isNotEmpty)
            ? map['authorName'] as String
            : 'Anonymous';

    final String safeAuthorId =
        (map['authorId'] is String) ? map['authorId'] as String : 'anonymous';

    final String safePostId =
        (map['postId'] is String) ? map['postId'] as String : '';

    final String safeContent =
        (map['content'] is String) ? map['content'] as String : '';

    final String safeAuthorBlock =
        (map['authorBlock'] is String) ? map['authorBlock'] as String : '';

    final int createdAtMillis =
        (map['createdAt'] is int)
            ? map['createdAt'] as int
            : DateTime.now().millisecondsSinceEpoch;

    final List<String> safeLikedBy =
        map['likedBy'] != null ? List<String>.from(map['likedBy']) : [];

    return Comment(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      postId: safePostId,
      authorId: safeAuthorId,
      authorName: safeAuthorName,
      authorBlock: safeAuthorBlock,
      authorAvatarUrl: map['authorAvatarUrl'],
      content: safeContent,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
      likes: map['likes'] ?? 0,
      likedBy: safeLikedBy,
      isLiked: safeLikedBy.contains(currentUserId),
    );
  }
}
