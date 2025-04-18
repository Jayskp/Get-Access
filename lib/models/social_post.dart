import 'package:flutter/material.dart';

/// Model class to represent social posts, polls, and events
class SocialPost {
  final String id;
  final String authorName;
  final String authorBlock;
  final String? authorAvatarUrl;
  final DateTime createdAt;
  final String content;
  final List<String>? imageUrls;
  final PostType type;
  final Map<String, dynamic>? additionalData;
  int likes;
  int comments;
  int shares;
  bool isLiked;

  // Poll-specific fields
  List<PollOption>? pollOptions;
  DateTime? pollEndDate;

  // Event-specific fields
  DateTime? eventDate;
  String? eventTime;
  String? eventVenue;

  SocialPost({
    required this.id,
    required this.authorName,
    required this.authorBlock,
    this.authorAvatarUrl,
    required this.createdAt,
    required this.content,
    this.imageUrls,
    required this.type,
    this.additionalData,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
    this.pollOptions,
    this.pollEndDate,
    this.eventDate,
    this.eventTime,
    this.eventVenue,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
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

  // Create a post from NewPost
  static SocialPost fromPost({
    required String authorName,
    required String authorBlock,
    String? authorAvatarUrl,
    required String content,
    List<String>? imageUrls,
  }) {
    return SocialPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: authorName,
      authorBlock: authorBlock,
      authorAvatarUrl: authorAvatarUrl,
      createdAt: DateTime.now(),
      content: content,
      imageUrls: imageUrls,
      type: PostType.post,
    );
  }

  // Create a poll post
  static SocialPost fromPoll({
    required String authorName,
    required String authorBlock,
    String? authorAvatarUrl,
    required String question,
    required List<PollOption> options,
    DateTime? endDate,
  }) {
    return SocialPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: authorName,
      authorBlock: authorBlock,
      authorAvatarUrl: authorAvatarUrl,
      createdAt: DateTime.now(),
      content: question,
      type: PostType.poll,
      pollOptions: options,
      pollEndDate: endDate ?? DateTime.now().add(const Duration(days: 7)),
    );
  }

  // Create an event post
  static SocialPost fromEvent({
    required String authorName,
    required String authorBlock,
    String? authorAvatarUrl,
    required String description,
    required DateTime eventDate,
    required String eventTime,
    required String eventVenue,
    List<String>? imageUrls,
  }) {
    return SocialPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: authorName,
      authorBlock: authorBlock,
      authorAvatarUrl: authorAvatarUrl,
      createdAt: DateTime.now(),
      content: description,
      imageUrls: imageUrls,
      type: PostType.event,
      eventDate: eventDate,
      eventTime: eventTime,
      eventVenue: eventVenue,
    );
  }

  void toggleLike() {
    if (isLiked) {
      likes--;
      isLiked = false;
    } else {
      likes++;
      isLiked = true;
    }
  }

  void incrementShares() {
    shares++;
  }
}

/// Represents a poll option with text and vote count
class PollOption {
  final String text;
  int votes;

  PollOption({required this.text, this.votes = 0});

  void vote() {
    votes++;
  }
}

/// Enum for the different types of social posts
enum PostType { post, poll, event }
