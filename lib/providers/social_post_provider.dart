import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/social_post.dart';

class SocialPostProvider extends ChangeNotifier {
  final List<SocialPost> _posts = [];
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  List<SocialPost> get posts => _posts;

  // Load posts from Firebase
  Future<void> loadPosts() async {
    try {
      isLoading = true;
      hasError = false;
      notifyListeners();

      final snapshot = await _database.child('Posts').once();
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;
      final String currentUserId =
          FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

      if (data != null) {
        _posts.clear();

        data.forEach((key, value) {
          try {
            _posts.add(
              SocialPost.fromMap(
                Map<String, dynamic>.from(value),
                currentUserId,
              ),
            );
          } catch (e) {
            print('Error parsing post: $e');
          }
        });

        // Sort posts by creation time (newest first)
        _posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading posts: $e');
      isLoading = false;
      hasError = true;
      errorMessage = 'Failed to load posts. Please try again.';
      notifyListeners();
    }
  }

  Future<void> addPost(SocialPost post) async {
    try {
      // Add to Firebase
      await _database.child('Posts').child(post.id).set(post.toMap());

      // Add to local state
      _posts.insert(0, post);
      notifyListeners();
    } catch (e) {
      print('Error adding post: $e');
    }
  }

  Future<void> deletePost(String id) async {
    try {
      // Delete from Firebase
      await _database.child('Posts').child(id).remove();

      // Also delete associated comments
      final commentsSnapshot =
          await _database
              .child('Comments')
              .orderByChild('postId')
              .equalTo(id)
              .once();

      final commentsData =
          commentsSnapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (commentsData != null) {
        commentsData.forEach((key, value) {
          _database.child('Comments').child(key).remove();
        });
      }

      // Update local state
      _posts.removeWhere((post) => post.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  Future<void> toggleLike(String id) async {
    final postIndex = _posts.indexWhere((post) => post.id == id);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    if (postIndex == -1) {
      print('Post not found: $id');
      return;
    }

    // Clone the post for error recovery
    final wasLiked = _posts[postIndex].isLiked;
    final previousLikes = _posts[postIndex].likes;
    final previousLikedBy = List<String>.from(_posts[postIndex].likedBy);

    try {
      // Optimistic update
      _posts[postIndex].toggleLike(currentUserId);
      notifyListeners(); // Update UI immediately

      // Update in Firebase
      await _database.child('Posts').child(id).update({
        'likes': _posts[postIndex].likes,
        'likedBy': _posts[postIndex].likedBy,
      });
    } catch (e) {
      // Revert on error
      print('Error toggling like: $e');
      _posts[postIndex].isLiked = wasLiked;
      _posts[postIndex].likes = previousLikes;
      _posts[postIndex].likedBy = previousLikedBy;
      notifyListeners();
      throw Exception('Failed to update like: $e');
    }
  }

  Future<void> incrementShares(String id) async {
    try {
      final postIndex = _posts.indexWhere((post) => post.id == id);

      if (postIndex != -1) {
        _posts[postIndex].incrementShares();

        // Update in Firebase
        await _database.child('Posts').child(id).update({
          'shares': _posts[postIndex].shares,
        });

        notifyListeners();
      }
    } catch (e) {
      print('Error incrementing shares: $e');
    }
  }

  Future<void> votePoll(String postId, int optionIndex) async {
    try {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      final currentUserId =
          FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

      if (postIndex != -1 &&
          _posts[postIndex].type == PostType.poll &&
          _posts[postIndex].pollOptions != null &&
          optionIndex < _posts[postIndex].pollOptions!.length) {
        // Check if user has already voted
        final hasVoted = _posts[postIndex].pollOptions!.any(
          (opt) => opt.votedBy.contains(currentUserId),
        );

        if (hasVoted) {
          throw Exception('You have already voted in this poll');
        }

        // Check if poll has ended
        if (_posts[postIndex].pollEndDate != null &&
            _posts[postIndex].pollEndDate!.isBefore(DateTime.now())) {
          throw Exception('This poll has ended');
        }

        // Add vote
        _posts[postIndex].pollOptions![optionIndex].vote(currentUserId);

        // Update in Firebase
        await _database.child('Posts').child(postId).update({
          'pollOptions':
              _posts[postIndex].pollOptions!.map((opt) => opt.toMap()).toList(),
        });

        notifyListeners();
      }
    } catch (e) {
      print('Error voting on poll: $e');
      rethrow; // Rethrow to handle in UI
    }
  }

  Future<void> toggleSave(String id) async {
    final postIndex = _posts.indexWhere((post) => post.id == id);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    if (postIndex == -1) {
      print('Post not found: $id');
      return;
    }

    // Clone the post for error recovery
    final wasSaved = _posts[postIndex].isSaved;
    final previousSavedBy = List<String>.from(_posts[postIndex].savedBy);

    try {
      // Optimistic update
      _posts[postIndex].toggleSave(currentUserId);
      notifyListeners(); // Update UI immediately

      // Update in Firebase
      await _database.child('Posts').child(id).update({
        'savedBy': _posts[postIndex].savedBy,
      });
    } catch (e) {
      // Revert on error
      print('Error toggling save: $e');
      _posts[postIndex].isSaved = wasSaved;
      _posts[postIndex].savedBy = previousSavedBy;
      notifyListeners();
      throw Exception('Failed to update save: $e');
    }
  }

  // Get saved posts for current user
  List<SocialPost> getSavedPosts() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    return _posts
        .where((post) => post.savedBy.contains(currentUserId))
        .toList();
  }

  // Add some sample posts for testing
  void addSamplePosts() async {
    // Only add sample posts if there are no posts yet
    if (_posts.isEmpty) {
      // Sample regular post
      final post1 = SocialPost(
        id: '1',
        authorId: 'sample_author',
        authorName: 'Brijesh Patel',
        authorBlock: '1402, Ansh Aarambh',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        content:
            'Available for Sell apartments at Ansh Aarambh, South Bopal available for Sale\n\n3 apartments each 3 BHK available for sale n ready possession at Ansh Aarambh Scheme at South Bopal, Ahmedabad\nB Tower, 1402, 1403 n 1404\n1460 sqft super built up',
        type: PostType.post,
        likes: 1,
        comments: 2,
        shares: 3,
      );

      // Sample poll
      final post2 = SocialPost(
        id: '2',
        authorId: 'sample_author',
        authorName: 'Dhruv',
        authorBlock: 'C Block, 104',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        content: 'What should be the timing of the next society meeting?',
        type: PostType.poll,
        pollOptions: [
          PollOption(text: 'Saturday Morning (10 AM)', votes: 12),
          PollOption(text: 'Saturday Evening (6 PM)', votes: 8),
          PollOption(text: 'Sunday Morning (10 AM)', votes: 15),
          PollOption(text: 'Sunday Evening (6 PM)', votes: 7),
        ],
        pollEndDate: DateTime.now().add(const Duration(days: 2)),
        likes: 5,
        comments: 3,
      );

      // Sample event
      final post3 = SocialPost(
        id: '3',
        authorId: 'sample_author',
        authorName: 'Raj Mehta',
        authorBlock: 'A Block, 302',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        content:
            'Join us for the Diwali celebration in our society. There will be music, dance, and delicious food!',
        type: PostType.event,
        eventDate: DateTime.now().add(const Duration(days: 5)),
        eventTime: '7:00 PM',
        eventVenue: 'Society Clubhouse',
        likes: 25,
        comments: 10,
        shares: 8,
      );

      await addPost(post1);
      await addPost(post2);
      await addPost(post3);
    }
  }
}
