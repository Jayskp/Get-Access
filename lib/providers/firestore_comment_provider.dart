import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment.dart';

class FirestoreCommentProvider extends ChangeNotifier {
  final Map<String, List<Comment>> _commentsByPost = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
            await _firestore
                .collection('comments')
                .where('postId', isEqualTo: postId)
                .orderBy('createdAt', descending: true)
                .get();

        final currentUserId =
            FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

        // Initialize as empty list by default
        _commentsByPost[postId] = [];

        if (snapshot.docs.isNotEmpty) {
          try {
            final List<Comment> comments = [];

            for (var doc in snapshot.docs) {
              try {
                final commentData = doc.data();
                final commentId = doc.id;

                // Ensure authorName exists and is not empty
                if (!commentData.containsKey('authorName') ||
                    commentData['authorName'] == null) {
                  commentData['authorName'] = 'Anonymous';
                } else if (commentData['authorName'] is String &&
                    (commentData['authorName'] as String).isEmpty) {
                  commentData['authorName'] = 'Anonymous';
                }

                comments.add(
                  Comment.fromMap(commentData, commentId, currentUserId),
                );
              } catch (e) {
                print('Error parsing individual comment: $e');
              }
            }

            _commentsByPost[postId] = comments;
          } catch (e) {
            print('Error parsing comments data: $e');
          }
        }
      } catch (e) {
        print('Error fetching comments from Firestore: $e');
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
      // Add to Firestore
      final commentRef = _firestore.collection('comments').doc();
      final commentWithId = comment.copyWith(id: commentRef.id);
      await commentRef.set(commentWithId.toMap());

      // Update local state
      if (_commentsByPost.containsKey(comment.postId)) {
        _commentsByPost[comment.postId]!.insert(0, commentWithId);
      } else {
        _commentsByPost[comment.postId] = [commentWithId];
      }

      // Update post comment count
      try {
        // Get the post reference
        final postRef = _firestore.collection('posts').doc(comment.postId);

        // Use transaction to safely update comment count
        await _firestore.runTransaction((transaction) async {
          final postDoc = await transaction.get(postRef);
          if (postDoc.exists) {
            final currentCount = postDoc.data()?['comments'] as int? ?? 0;
            transaction.update(postRef, {'comments': currentCount + 1});
          }
        });
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

  // Toggle like on a comment
  Future<void> toggleLike(String postId, String commentId) async {
    try {
      final currentUserId =
          FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      final commentList = _commentsByPost[postId];

      if (commentList != null) {
        final commentIndex = commentList.indexWhere((c) => c.id == commentId);

        if (commentIndex != -1) {
          final oldComment = commentList[commentIndex];

          // Create new comment with updated like status
          final updatedComment = oldComment.toggleLike(currentUserId);

          // Update local state
          commentList[commentIndex] = updatedComment;
          notifyListeners();

          // Update in Firestore
          final commentRef = _firestore.collection('comments').doc(commentId);
          await commentRef.update({
            'likes': updatedComment.likes,
            'likedBy': updatedComment.likedBy,
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

      // Then remove from Firestore
      await _firestore.collection('comments').doc(commentId).delete();

      // Update comment count
      try {
        // Get the post reference
        final postRef = _firestore.collection('posts').doc(postId);

        // Use transaction to safely update comment count
        await _firestore.runTransaction((transaction) async {
          final postDoc = await transaction.get(postRef);
          if (postDoc.exists) {
            final currentCount = postDoc.data()?['comments'] as int? ?? 0;
            // Only decrement if greater than 0
            if (currentCount > 0) {
              transaction.update(postRef, {'comments': currentCount - 1});
            }
          }
        });
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
          await _firestore
              .collection('comments')
              .where('postId', isEqualTo: postId)
              .count()
              .get();

      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting comment count: $e');
      return 0;
    }
  }

  // Sync the comment count with the actual number of comments
  Future<void> syncCommentCount(String postId) async {
    try {
      final count = await getAccurateCommentCount(postId);

      // Get the post reference and update the comment count
      await _firestore.collection('posts').doc(postId).update({
        'comments': count,
      });
    } catch (e) {
      print('Error syncing comment count: $e');
    }
  }

  // Listen for real-time updates on comments for a post
  Stream<List<Comment>> listenToComments(String postId) {
    return _firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final currentUserId =
              FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Comment.fromMap(data, doc.id, currentUserId);
          }).toList();
        });
  }
}
