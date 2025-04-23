import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/comment.dart';

class CommentProvider extends ChangeNotifier {
  final Map<String, List<Comment>> _commentsByPost = {};
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final Map<String, bool> _loadingStates =
      {}; // Track loading states for each post

  // Get all comments for a post
  List<Comment> getCommentsForPost(String postId) {
    return _commentsByPost[postId] ?? [];
  }

  // Check if comments are loading for a specific post
  bool isLoadingForPost(String postId) {
    return _loadingStates[postId] ?? false;
  }

  // Load comments for a specific post
  Future<void> loadCommentsForPost(String postId) async {
    // Don't reload if already loading this post
    if (_loadingStates[postId] == true) return;

    try {
      _loadingStates[postId] = true;
      notifyListeners();

      try {
        final snapshot =
            await _database
                .child('Comments')
                .orderByChild('postId')
                .equalTo(postId)
                .once();

        final currentUserId =
            FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

        // Initialize as empty list by default
        _commentsByPost[postId] = [];

        if (snapshot.snapshot.value != null) {
          try {
            final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
            final List<Comment> comments = [];

            data.forEach((key, value) {
              try {
                // Ensure the value is valid and has required fields
                if (value is Map) {
                  final Map<String, dynamic> commentData =
                      Map<String, dynamic>.from(value);

                  // Ensure authorName exists and is not empty
                  if (!commentData.containsKey('authorName') ||
                      commentData['authorName'] == null) {
                    commentData['authorName'] = 'Anonymous';
                  } else if (commentData['authorName'] is String &&
                      (commentData['authorName'] as String).isEmpty) {
                    commentData['authorName'] = 'Anonymous';
                  }

                  comments.add(
                    Comment.fromMap(commentData, key, currentUserId),
                  );
                }
              } catch (e) {
                print('Error parsing individual comment: $e');
              }
            });

            // Sort comments by creation time (newest first)
            comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            _commentsByPost[postId] = comments;
          } catch (e) {
            print('Error parsing comments data: $e');
          }
        }
      } catch (e) {
        print('Error fetching comments from Firebase: $e');
      }

      _loadingStates[postId] = false;
      notifyListeners();
    } catch (e) {
      print('Error in loadCommentsForPost: $e');
      _loadingStates[postId] = false;
      notifyListeners();
    }
  }

  // Add a new comment
  Future<void> addComment(Comment comment) async {
    try {
      // Add to Firebase
      await _database.child('Comments').child(comment.id).set(comment.toMap());

      // Update local state
      if (_commentsByPost.containsKey(comment.postId)) {
        _commentsByPost[comment.postId]!.insert(0, comment);
      } else {
        _commentsByPost[comment.postId] = [comment];
      }

      // Safely update post comment count without using transactions
      try {
        // Get the post reference
        final postRef = _database.child('Posts').child(comment.postId);

        // Get current comments count from the post
        final snapshot = await postRef.once();
        if (snapshot.snapshot.value != null) {
          final postData = snapshot.snapshot.value as Map<dynamic, dynamic>;
          final currentCount = postData['comments'] as int? ?? 0;

          // Update with incremented count
          await postRef.update({'comments': currentCount + 1});
        }
      } catch (e) {
        print('Error updating comment count: $e');
        // Don't rethrow this specific error to allow comment to be added
      }

      notifyListeners();
    } catch (e) {
      print('Error adding comment: $e');
      rethrow;
    }
  }

  // Toggle like on a comment with optimistic updates
  Future<void> toggleLike(String postId, String commentId) async {
    try {
      final currentUserId =
          FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      final commentList = _commentsByPost[postId];

      if (commentList != null) {
        final commentIndex = commentList.indexWhere((c) => c.id == commentId);

        if (commentIndex != -1) {
          final comment = commentList[commentIndex];

          // Optimistic update
          comment.toggleLike(currentUserId);
          notifyListeners();

          // Update in Firebase
          await _database.child('Comments').child(commentId).update({
            'likes': comment.likes,
            'likedBy': comment.likedBy,
          });
        }
      }
    } catch (e) {
      print('Error toggling comment like: $e');
      // If error, reload comments to reset state
      loadCommentsForPost(postId);
    }
  }

  // Delete a comment with optimistic update
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      // Optimistic update - remove from local state first
      List<Comment>? comments = _commentsByPost[postId];

      if (comments != null) {
        final index = comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          comments.removeAt(index);
          notifyListeners();
        }
      }

      // Then remove from Firebase
      await _database.child('Comments').child(commentId).remove();

      // Safely update comment count without transactions
      try {
        // Get the post reference
        final postRef = _database.child('Posts').child(postId);

        // Get current comments count from the post
        final snapshot = await postRef.once();
        if (snapshot.snapshot.value != null) {
          final postData = snapshot.snapshot.value as Map<dynamic, dynamic>;
          final currentCount = postData['comments'] as int? ?? 0;

          // Only decrement if greater than 0
          if (currentCount > 0) {
            await postRef.update({'comments': currentCount - 1});
          }
        }
      } catch (e) {
        print('Error updating comment count: $e');
      }
    } catch (e) {
      print('Error deleting comment: $e');
      // If error, reload comments to reset state
      loadCommentsForPost(postId);
    }
  }

  // Get the accurate comment count for a post
  Future<int> getAccurateCommentCount(String postId) async {
    try {
      final snapshot =
          await _database
              .child('Comments')
              .orderByChild('postId')
              .equalTo(postId)
              .once();

      if (snapshot.snapshot.value == null) {
        return 0;
      }

      try {
        final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
        return data.length;
      } catch (e) {
        // If casting fails, return 0
        print('Error casting comment data: $e');
        return 0;
      }
    } catch (e) {
      print('Error getting comment count: $e');
      return 0;
    }
  }

  // Sync the comment count with the actual number of comments
  Future<void> syncCommentCount(String postId) async {
    try {
      final count = await getAccurateCommentCount(postId);

      // Get the post reference
      final postRef = _database.child('Posts').child(postId);

      // Update the comment count
      await postRef.update({'comments': count});
    } catch (e) {
      print('Error syncing comment count: $e');
    }
  }
}
