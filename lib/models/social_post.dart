import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Model class to represent social posts, polls, and events
class SocialPost {
  final String id;
  final String authorId;
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
  List<String> likedBy;
  bool isLiked;
  bool isSaved;
  List<String> savedBy;

  // Poll-specific fields
  List<PollOption>? pollOptions;
  DateTime? pollEndDate;

  // Event-specific fields
  DateTime? eventDate;
  String? eventTime;
  String? eventVenue;

  SocialPost({
    required this.id,
    required this.authorId,
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
    List<String>? likedBy,
    this.isLiked = false,
    this.isSaved = false,
    List<String>? savedBy,
    this.pollOptions,
    this.pollEndDate,
    this.eventDate,
    this.eventTime,
    this.eventVenue,
  }) : this.likedBy = likedBy != null ? List<String>.from(likedBy) : [],
       this.savedBy = savedBy != null ? List<String>.from(savedBy) : [];

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
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    return SocialPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: userId,
      authorName: authorName,
      authorBlock: authorBlock,
      authorAvatarUrl: authorAvatarUrl,
      createdAt: DateTime.now(),
      content: content,
      imageUrls: imageUrls,
      type: PostType.post,
      likes: 0,
      comments: 0,
      shares: 0,
      likedBy: [],
      savedBy: [],
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
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    return SocialPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: userId,
      authorName: authorName,
      authorBlock: authorBlock,
      authorAvatarUrl: authorAvatarUrl,
      createdAt: DateTime.now(),
      content: question,
      type: PostType.poll,
      pollOptions: options,
      pollEndDate: endDate ?? DateTime.now().add(const Duration(days: 7)),
      likes: 0,
      comments: 0,
      shares: 0,
      likedBy: [],
      savedBy: [],
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
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    return SocialPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: userId,
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
      likes: 0,
      comments: 0,
      shares: 0,
      likedBy: [],
      savedBy: [],
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

  void incrementComments() {
    comments++;
  }

  void toggleSave(String userId) {
    if (savedBy.contains(userId)) {
      savedBy.remove(userId);
      isSaved = false;
    } else {
      savedBy.add(userId);
      isSaved = true;
    }
  }

  // For Firebase storage
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorBlock': authorBlock,
      'authorAvatarUrl': authorAvatarUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'content': content,
      'imageUrls': imageUrls,
      'type': type.name,
      'additionalData': additionalData,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'likedBy': likedBy,
      'savedBy': savedBy,
    };

    if (type == PostType.poll) {
      data['pollOptions'] = pollOptions?.map((opt) => opt.toMap()).toList();
      data['pollEndDate'] = pollEndDate?.millisecondsSinceEpoch;
    } else if (type == PostType.event) {
      data['eventDate'] = eventDate?.millisecondsSinceEpoch;
      data['eventTime'] = eventTime;
      data['eventVenue'] = eventVenue;
    }

    return data;
  }

  factory SocialPost.fromMap(Map<String, dynamic> map, String currentUserId) {
    final type = PostType.values.firstWhere(
      (e) => e.name == map['type'],
      orElse: () => PostType.post,
    );

    List<PollOption>? pollOptions;
    if (type == PostType.poll && map['pollOptions'] != null) {
      pollOptions =
          (map['pollOptions'] as List)
              .map((opt) => PollOption.fromMap(opt))
              .toList();
    }

    // Extract and ensure all lists are modifiable
    List<String> extractedLikedBy = [];
    if (map['likedBy'] != null) {
      extractedLikedBy = List<String>.from(map['likedBy']);
    }

    List<String> extractedSavedBy = [];
    if (map['savedBy'] != null) {
      extractedSavedBy = List<String>.from(map['savedBy']);
    }

    List<String>? extractedImageUrls;
    if (map['imageUrls'] != null) {
      extractedImageUrls = List<String>.from(map['imageUrls']);
    }

    // Ensure counts are initialized properly
    final int likes = map['likes'] ?? 0;
    final int comments = map['comments'] ?? 0;
    final int shares = map['shares'] ?? 0; // Explicitly default to 0

    return SocialPost(
      id: map['id'],
      authorId: map['authorId'],
      authorName: map['authorName'],
      authorBlock: map['authorBlock'],
      authorAvatarUrl: map['authorAvatarUrl'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      content: map['content'],
      imageUrls: extractedImageUrls,
      type: type,
      additionalData: map['additionalData'],
      likes: likes,
      comments: comments,
      shares: shares,
      likedBy: extractedLikedBy,
      isLiked: extractedLikedBy.contains(currentUserId),
      isSaved: extractedSavedBy.contains(currentUserId),
      savedBy: extractedSavedBy,
      pollOptions: pollOptions,
      pollEndDate:
          map['pollEndDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['pollEndDate'])
              : null,
      eventDate:
          map['eventDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['eventDate'])
              : null,
      eventTime: map['eventTime'],
      eventVenue: map['eventVenue'],
    );
  }
}

/// Represents a poll option with text and vote count
class PollOption {
  final String text;
  int votes;
  List<String> votedBy;

  PollOption({required this.text, this.votes = 0, List<String>? votedBy})
    : this.votedBy = votedBy != null ? List<String>.from(votedBy) : [];

  void vote(String userId) {
    if (!votedBy.contains(userId)) {
      votes++;
      votedBy.add(userId);
    }
  }

  Map<String, dynamic> toMap() {
    return {'text': text, 'votes': votes, 'votedBy': votedBy};
  }

  factory PollOption.fromMap(Map<String, dynamic> map) {
    return PollOption(
      text: map['text'],
      votes: map['votes'] ?? 0,
      votedBy: map['votedBy'] != null ? List<String>.from(map['votedBy']) : [],
    );
  }
}

/// Enum for the different types of social posts
enum PostType { post, poll, event }
