import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/social_post.dart';
import '../providers/social_post_provider.dart';

class SocialPostCard extends StatelessWidget {
  final SocialPost post;
  final VoidCallback? onTap;

  const SocialPostCard({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildContent(context),
          if (post.type == PostType.poll) _buildPollOptions(context),
          if (post.type == PostType.event) _buildEventDetails(context),
          if (post.imageUrls != null && post.imageUrls!.isNotEmpty)
            _buildImageSection(),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            child:
                post.authorAvatarUrl != null
                    ? null
                    : Text(
                      post.authorName.isNotEmpty
                          ? post.authorName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.authorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${post.authorBlock} · ${post.timeAgo}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation(context);
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    String title = '';
    if (post.type == PostType.poll) {
      title = 'Poll: ';
    } else if (post.type == PostType.event) {
      title = 'Event: ';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          Text(post.content, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPollOptions(BuildContext context) {
    if (post.pollOptions == null || post.pollOptions!.isEmpty) {
      return Container();
    }

    final totalVotes = post.pollOptions!.fold<int>(
      0,
      (sum, option) => sum + option.votes,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total votes: $totalVotes',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 12),
          ...post.pollOptions!.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final percentage =
                totalVotes > 0
                    ? (option.votes / totalVotes * 100).toStringAsFixed(0)
                    : '0';

            return GestureDetector(
              onTap: () {
                Provider.of<SocialPostProvider>(
                  context,
                  listen: false,
                ).votePoll(post.id, index);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.text, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Stack(
                      children: [
                        Container(
                          height: 36,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor:
                              totalVotes > 0 ? option.votes / totalVotes : 0.0,
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.green.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 12),
                            child: Text(
                              '$percentage%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          if (post.pollEndDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Poll ends on: ${_formatDate(post.pollEndDate!)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEventDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18),
              const SizedBox(width: 8),
              Text(
                'Date: ${_formatDate(post.eventDate!)}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 18),
              const SizedBox(width: 8),
              Text(
                'Time: ${post.eventTime}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18),
              const SizedBox(width: 8),
              Text(
                'Venue: ${post.eventVenue}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    if (post.imageUrls == null || post.imageUrls!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: 200,
      width: double.infinity,
      child: PageView.builder(
        itemCount: post.imageUrls!.length,
        itemBuilder: (context, index) {
          return Image.asset(post.imageUrls![index], fit: BoxFit.cover);
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${post.likes} likes',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const Spacer(),
              if (post.comments > 0)
                Text(
                  '${post.comments} comments',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              if (post.comments > 0 && post.shares > 0)
                Text(
                  ' · ',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              if (post.shares > 0)
                Text(
                  '${post.shares} shares',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                context,
                icon: post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                label: 'Like',
                color: post.isLiked ? Colors.blue : Colors.grey.shade700,
                onTap: () {
                  Provider.of<SocialPostProvider>(
                    context,
                    listen: false,
                  ).toggleLike(post.id);
                },
              ),
              _buildActionButton(
                context,
                icon: Icons.comment_outlined,
                label: 'Comment',
                onTap: () {
                  // Implement comment functionality
                },
              ),
              _buildActionButton(
                context,
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () {
                  _sharePost(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color ?? Colors.grey.shade700),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color ?? Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Post'),
            content: const Text('Are you sure you want to delete this post?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<SocialPostProvider>(
                    context,
                    listen: false,
                  ).deletePost(post.id);
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'DELETE',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _sharePost(BuildContext context) async {
    String shareText;

    switch (post.type) {
      case PostType.post:
        shareText = '${post.authorName} posted: ${post.content}';
        break;
      case PostType.poll:
        shareText = '${post.authorName} created a poll: ${post.content}';
        if (post.pollOptions != null && post.pollOptions!.isNotEmpty) {
          shareText += '\nOptions:';
          for (var option in post.pollOptions!) {
            shareText += '\n- ${option.text}';
          }
        }
        break;
      case PostType.event:
        shareText =
        '${post.authorName} is hosting an event: ${post.content}\n'
            'Date: ${_formatDate(post.eventDate!)}\n'
            'Time: ${post.eventTime}\n'
            'Venue: ${post.eventVenue}';
        break;
    }

    try {
      // show the native share sheet first
      await Share.share(shareText);

      // only after successful share, increment the counter
      Provider.of<SocialPostProvider>(context, listen: false)
          .incrementShares(post.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not share: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
