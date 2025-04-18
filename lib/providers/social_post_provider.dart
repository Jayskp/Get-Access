import 'package:flutter/material.dart';
import '../models/social_post.dart';

class SocialPostProvider extends ChangeNotifier {
  final List<SocialPost> _posts = [];

  List<SocialPost> get posts => _posts;

  void addPost(SocialPost post) {
    _posts.add(post);
    notifyListeners();
  }

  void deletePost(String id) {
    _posts.removeWhere((post) => post.id == id);
    notifyListeners();
  }

  void toggleLike(String id) {
    final postIndex = _posts.indexWhere((post) => post.id == id);
    if (postIndex != -1) {
      _posts[postIndex].toggleLike();
      notifyListeners();
    }
  }

  void incrementShares(String id) {
    final postIndex = _posts.indexWhere((post) => post.id == id);
    if (postIndex != -1) {
      _posts[postIndex].incrementShares();
      notifyListeners();
    }
  }

  void votePoll(String postId, int optionIndex) {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1 &&
        _posts[postIndex].type == PostType.poll &&
        _posts[postIndex].pollOptions != null &&
        optionIndex < _posts[postIndex].pollOptions!.length) {
      _posts[postIndex].pollOptions![optionIndex].vote();
      notifyListeners();
    }
  }

  // Add some sample posts for testing
  void addSamplePosts() {
    // Sample regular post
    _posts.add(
      SocialPost(
        id: '1',
        authorName: 'Brijesh Patel',
        authorBlock: '1402, Ansh Aarambh',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        content:
            'Available for Sell apartments at Ansh Aarambh, South Bopal available for Sale\n\n3 apartments each 3 BHK available for sale n ready possession at Ansh Aarambh Scheme at South Bopal, Ahmedabad\nB Tower, 1402, 1403 n 1404\n1460 sqft super built up',
        type: PostType.post,
        likes: 1,
        comments: 2,
        shares: 3,
      ),
    );

    // Sample poll
    _posts.add(
      SocialPost(
        id: '2',
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
      ),
    );

    // Sample event
    _posts.add(
      SocialPost(
        id: '3',
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
      ),
    );

    notifyListeners();
  }
}
