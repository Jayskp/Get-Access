import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/social_post.dart';

class FirestorePostProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Store posts by source (all, featured, user-specific)
  final Map<String, List<SocialPost>> _postsBySource = {};

  // Track loading states for different post sources
  final Map<String, bool> _loadingStates = {};

  // Get current user ID
  String get _currentUserId => _auth.currentUser?.uid ?? '';

  // Get posts for a specific source
  List<SocialPost> getPostsForSource(String source) {
    return _postsBySource[source] ?? [];
  }

  // Check if posts are loading for a specific source
  bool isLoadingForSource(String source) {
    return _loadingStates[source] ?? false;
  }

  // Load posts for a specific source
  Future<void> loadPostsForSource(String source, {int limit = 20}) async {
    // Skip if already loading
    if (_loadingStates[source] == true) return;

    _loadingStates[source] = true;
    notifyListeners();

    try {
      Query query = _firestore.collection('posts');

      // Apply source-specific filters
      if (source == 'featured') {
        query = query.where('isFeatured', isEqualTo: true);
      } else if (source.startsWith('user_')) {
        final userId = source.substring(5); // Remove 'user_' prefix
        query = query.where('authorId', isEqualTo: userId);
      }

      // Get posts ordered by creation time
      final querySnapshot =
          await query.orderBy('createdAt', descending: true).limit(limit).get();

      // Convert to SocialPost objects
      final posts =
          querySnapshot.docs.map((doc) {
            return SocialPost.fromMap(
              doc.data() as Map<String, dynamic>,
              _currentUserId,
            );
          }).toList();

      // Update the state
      _postsBySource[source] = posts;
    } catch (e) {
      print('Error loading posts for $source: $e');
    } finally {
      _loadingStates[source] = false;
      notifyListeners();
    }
  }

  // Create a new post
  Future<String?> createPost(SocialPost post) async {
    try {
      // Add to Firestore
      final docRef = await _firestore.collection('posts').add(post.toMap());

      // Add the new post to the cached lists (all posts and user posts)
      final newPost = SocialPost.fromMap({
        ...post.toMap(),
        'id': docRef.id,
      }, _currentUserId);

      // Update 'all' posts
      final allPosts = _postsBySource['all'] ?? [];
      _postsBySource['all'] = [newPost, ...allPosts];

      // Update user posts
      final userSource = 'user_${post.authorId}';
      final userPosts = _postsBySource[userSource] ?? [];
      _postsBySource[userSource] = [newPost, ...userPosts];

      notifyListeners();
      return docRef.id;
    } catch (e) {
      print('Error creating post: $e');
      return null;
    }
  }

  // Toggle like on a post
  Future<void> toggleLike(String postId, String source) async {
    try {
      final posts = _postsBySource[source];
      if (posts == null) return;

      // Find the post
      final postIndex = posts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return;

      final post = posts[postIndex];

      // Toggle like
      post.toggleLike(_currentUserId);

      // Also update the post in any other cached sources
      _postsBySource.forEach((sourceKey, sourcePosts) {
        if (sourceKey == source) return; // Already updated

        final otherIndex = sourcePosts.indexWhere((p) => p.id == postId);
        if (otherIndex != -1) {
          sourcePosts[otherIndex].toggleLike(_currentUserId);
        }
      });

      notifyListeners();

      // Update in Firestore
      await _firestore.collection('posts').doc(postId).update({
        'likes': post.likes,
        'likedBy': post.likedBy,
      });
    } catch (e) {
      print('Error toggling like: $e');
      // Revert the optimistic update on error
      await loadPostsForSource(source);
    }
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    try {
      // Delete from Firestore
      await _firestore.collection('posts').doc(postId).delete();

      // Remove from all cached sources
      _postsBySource.forEach((source, posts) {
        _postsBySource[source] =
            posts.where((post) => post.id != postId).toList();
      });

      notifyListeners();
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  // Update comments count for a post
  Future<void> updateCommentsCount(String postId, int commentCount) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'comments': commentCount,
      });

      // Update in all cached sources
      _postsBySource.forEach((source, posts) {
        final postIndex = posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          posts[postIndex].comments = commentCount;
        }
      });

      notifyListeners();
    } catch (e) {
      print('Error updating comments count: $e');
    }
  }

  // Increment views for a post
  Future<void> incrementShares(String postId) async {
    try {
      // Use Firestore transaction to safely increment
      await _firestore.runTransaction((transaction) async {
        final docRef = _firestore.collection('posts').doc(postId);
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) return;

        final currentShares = (snapshot.data()?['shares'] as int?) ?? 0;
        transaction.update(docRef, {'shares': currentShares + 1});

        // Update in all cached sources
        _postsBySource.forEach((source, posts) {
          final postIndex = posts.indexWhere((post) => post.id == postId);
          if (postIndex != -1) {
            posts[postIndex].shares = currentShares + 1;
          }
        });
      });

      notifyListeners();
    } catch (e) {
      print('Error incrementing shares: $e');
    }
  }

  // Toggle featured status (admin only)
  Future<void> toggleFeatured(String postId) async {
    try {
      // Find the post in any cached source
      SocialPost? targetPost;

      for (final posts in _postsBySource.values) {
        final postIndex = posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          targetPost = posts[postIndex];
          break;
        }
      }

      if (targetPost == null) return;

      // Update in Firestore
      await _firestore.collection('posts').doc(postId).update({
        'isFeatured': !targetPost.isFeatured,
      });

      // Update in all cached sources
      _postsBySource.forEach((source, posts) {
        final postIndex = posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          posts[postIndex] = posts[postIndex].copyWith(
            isFeatured: !targetPost!.isFeatured,
          );
        }
      });

      // If we're toggling off featured and viewing featured posts, remove it
      if (targetPost.isFeatured && _postsBySource.containsKey('featured')) {
        _postsBySource['featured'] =
            _postsBySource['featured']!
                .where((post) => post.id != postId)
                .toList();
      }

      notifyListeners();
    } catch (e) {
      print('Error toggling featured status: $e');
    }
  }

  // Listen to real-time updates for a list of posts
  void listenToPostUpdates(String source) {
    Query query = _firestore.collection('posts');

    // Apply source-specific filters
    if (source == 'featured') {
      query = query.where('isFeatured', isEqualTo: true);
    } else if (source.startsWith('user_')) {
      final userId = source.substring(5);
      query = query.where('authorId', isEqualTo: userId);
    }

    // Set up real-time listener
    query
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .listen(
          (snapshot) {
            // Convert to SocialPost objects
            final posts =
                snapshot.docs.map((doc) {
                  return SocialPost.fromMap(
                    doc.data() as Map<String, dynamic>,
                    _currentUserId,
                  );
                }).toList();

            // Update state
            _postsBySource[source] = posts;
            notifyListeners();
          },
          onError: (error) {
            print('Error listening to posts for $source: $error');
          },
        );
  }
}
