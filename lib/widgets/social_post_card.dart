import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_serviices.dart';
import '../models/social_post.dart';
import '../providers/social_post_provider.dart';
import '../widgets/comment_section.dart';
import '../providers/comment_provider.dart';

class SocialPostCard extends StatefulWidget {
  final SocialPost post;
  final VoidCallback? onTap;
  final Function(String) onReport;

  const SocialPostCard({
    Key? key,
    required this.post,
    this.onTap,
    required this.onReport,
  }) : super(key: key);

  @override
  State<SocialPostCard> createState() => _SocialPostCardState();
}

class _SocialPostCardState extends State<SocialPostCard>
    with SingleTickerProviderStateMixin {
  bool _isLiking = false;
  bool _isSharing = false;
  late final AnimationController _likeController;
  late final Animation<double> _likeAnimation;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _likeAnimation = Tween(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _likeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  Future<void> _handleShare() async {
    setState(() => _isSharing = true);
    try {
      // Share the content first
      await Share.share(
        'Check out this post by ${widget.post.authorName}: ${widget.post.content}\n\nShared via Get-Access App',
        subject: 'Interesting post from Get-Access',
      );

      // Then increment the share count
      await Provider.of<SocialPostProvider>(
        context,
        listen: false,
      ).incrementShares(widget.post.id);
    } catch (e) {
      print('Error sharing: $e');
      // Show error if needed
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to share: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Text('Report Post'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.report_problem),
                  title: const Text('Inappropriate Content'),
                  onTap: () {
                    widget.onReport('inappropriate');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.copyright),
                  title: const Text('Copyright Violation'),
                  onTap: () {
                    widget.onReport('copyright');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.warning),
                  title: const Text('Spam'),
                  onTap: () {
                    widget.onReport('spam');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          if (widget.post.imageUrls != null &&
              widget.post.imageUrls!.isNotEmpty)
            _buildImageSection(),
          _buildContent(context),
          if (widget.post.type == PostType.poll) _buildPollOptions(context),
          if (widget.post.type == PostType.event) _buildEventDetails(context),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                widget.post.authorAvatarUrl != null
                    ? NetworkImage(widget.post.authorAvatarUrl!)
                    : null,
            child:
                widget.post.authorAvatarUrl == null
                    ? Text(
                      widget.post.authorName.isNotEmpty
                          ? widget.post.authorName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.authorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${widget.post.authorBlock} · ${widget.post.timeAgo}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => _showPostOptions(context),
            splashRadius: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.post.type == PostType.poll ||
              widget.post.type == PostType.event)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    widget.post.type == PostType.poll
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.post.type == PostType.poll ? 'Poll' : 'Event',
                style: TextStyle(
                  color:
                      widget.post.type == PostType.poll
                          ? Colors.blue
                          : Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          Text(widget.post.content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildPollOptions(BuildContext context) {
    if (widget.post.pollOptions == null || widget.post.pollOptions!.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalVotes = widget.post.pollOptions!.fold<int>(
      0,
      (sum, opt) => sum + opt.votes,
    );

    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    final hasVoted = widget.post.pollOptions!.any(
      (opt) => opt.votedBy.contains(currentUserId),
    );

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.post.pollOptions!.asMap().entries.map((entry) {
            final idx = entry.key;
            final option = entry.value;
            final pct =
                totalVotes > 0 ? (option.votes / totalVotes) * 100 : 0.0;
            final isSelected = option.votedBy.contains(currentUserId);

            return InkWell(
              onTap:
                  hasVoted
                      ? null
                      : () async {
                        try {
                          await Provider.of<SocialPostProvider>(
                            context,
                            listen: false,
                          ).votePoll(widget.post.id, idx);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to vote: $e')),
                          );
                        }
                      },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border:
                      idx < widget.post.pollOptions!.length - 1
                          ? Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          )
                          : null,
                  color: isSelected ? Colors.blue.withOpacity(0.05) : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                size: 20,
                                color:
                                    isSelected
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  option.text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                    color: isSelected ? Colors.blue : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${pct.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color:
                                isSelected ? Colors.blue : Colors.grey.shade600,
                            fontSize: 14,
                            fontWeight:
                                isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        // Background progress bar
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        // Foreground progress bar
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 6,
                          width:
                              (MediaQuery.of(context).size.width - 48) *
                              (pct / 100),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.blue : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  Icons.how_to_vote_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  '$totalVotes ${totalVotes == 1 ? 'vote' : 'votes'}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(width: 12),
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  _formatTimeLeft(),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeLeft() {
    if (widget.post.pollEndDate == null) return 'No end date';
    final now = DateTime.now();
    final difference = widget.post.pollEndDate!.difference(now);
    if (difference.isNegative) return 'Poll ended';
    if (difference.inDays > 0) {
      return '${difference.inDays}d left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h left';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m left';
    } else {
      return 'Ending soon';
    }
  }

  Widget _buildEventDetails(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildEventDetailRow(
            Icons.calendar_today,
            'Date',
            _formatDate(widget.post.eventDate!),
          ),
          const SizedBox(height: 12),
          _buildEventDetailRow(
            Icons.access_time,
            'Time',
            widget.post.eventTime ?? 'Not specified',
          ),
          const SizedBox(height: 12),
          _buildEventDetailRow(
            Icons.location_on,
            'Venue',
            widget.post.eventVenue ?? 'Not specified',
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    final String path = widget.post.imageUrls!.first;
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: Image.file(File(path), fit: BoxFit.cover, width: double.infinity),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Consumer<SocialPostProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      try {
                        // Trigger animation
                        if (!widget.post.isLiked) {
                          _likeController.forward().then(
                            (_) => _likeController.reverse(),
                          );
                        }

                        // Toggle like
                        await provider.toggleLike(widget.post.id);
                      } catch (e) {
                        // Show error if needed
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update like: $e')),
                        );
                      }
                    },
                    child: ScaleTransition(
                      scale: _likeAnimation,
                      child: Icon(
                        widget.post.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            widget.post.isLiked ? Colors.red : Colors.black87,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.post.likes}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    context,
                    icon: Icons.chat_bubble_outline,
                    onTap: () => _showComments(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.post.comments}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    context,
                    icon: Icons.share_outlined,
                    onTap: _isSharing ? null : () => _handleShare(),
                    isLoading: _isSharing,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.post.shares}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  _buildActionButton(
                    context,
                    icon:
                        widget.post.isSaved
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                    color: widget.post.isSaved ? Colors.blue : null,
                    onTap: () async {
                      await provider.toggleSave(widget.post.id);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showComments(BuildContext context) {
    // Show the comments immediately to improve UX
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder:
                (_, controller) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(child: CommentSection(post: widget.post)),
                    ],
                  ),
                ),
          ),
    );

    // Update the counts after showing the comments
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;

      try {
        // Sync comment count in the background
        final commentProvider = Provider.of<CommentProvider>(
          context,
          listen: false,
        );
        await commentProvider.syncCommentCount(widget.post.id);

        if (!context.mounted) return;

        // Get accurate count
        final accurateCount = await commentProvider.getAccurateCommentCount(
          widget.post.id,
        );

        if (!context.mounted) return;

        // Update the post's comment count if needed
        if (widget.post.comments != accurateCount) {
          widget.post.comments = accurateCount;
          Provider.of<SocialPostProvider>(
            context,
            listen: false,
          ).notifyListeners();
        }
      } catch (e) {
        print('Error updating comment counts: $e');
      }
    });
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onTap,
    Color? color,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child:
            isLoading
                ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      color ?? Colors.black87,
                    ),
                  ),
                )
                : Icon(icon, size: 24, color: color ?? Colors.black87),
      ),
    );
  }

  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => FutureBuilder<bool>(
            future: AuthService.isAdmin(),
            builder: (context, adminSnapshot) {
              final isAdmin = adminSnapshot.data ?? false;

              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Show delete option if user is post author or admin
                    if (widget.post.authorId ==
                            FirebaseAuth.instance.currentUser?.uid ||
                        isAdmin)
                      ListTile(
                        leading: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        title: const Text(
                          'Delete post',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _showDeleteConfirmation(context, isAdmin);
                        },
                      ),

                    if (isAdmin && !widget.post.isFeatured)
                      ListTile(
                        leading: const Icon(
                          Icons.star_outline,
                          color: Colors.amber,
                        ),
                        title: const Text('Feature post'),
                        onTap: () {
                          Navigator.pop(context);
                          _toggleFeaturePost(context);
                        },
                      ),

                    if (isAdmin && widget.post.isFeatured)
                      ListTile(
                        leading: const Icon(
                          Icons.star_outline,
                          color: Colors.grey,
                        ),
                        title: const Text('Unfeature post'),
                        onTap: () {
                          Navigator.pop(context);
                          _toggleFeaturePost(context);
                        },
                      ),

                    ListTile(
                      leading: const Icon(Icons.report_outlined),
                      title: const Text('Report'),
                      onTap: () {
                        Navigator.pop(context);
                        _showReportDialog();
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, bool isAdmin) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Post'),
            content: Text(
              'Are you sure you want to delete this post? ${isAdmin ? 'You are deleting this as an admin.' : ''}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () async {
                  if (isAdmin) {
                    // Use admin delete method
                    await AuthService.deletePost(widget.post.id);
                  } else {
                    // Use standard delete method
                    Provider.of<SocialPostProvider>(
                      context,
                      listen: false,
                    ).deletePost(widget.post.id);
                  }
                  Navigator.pop(context);
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

  void _toggleFeaturePost(BuildContext context) async {
    try {
      await AuthService.toggleFeaturePost(
        widget.post.id,
        !widget.post.isFeatured,
      );

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.post.isFeatured
                ? 'Post unfeatured successfully'
                : 'Post featured successfully',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
