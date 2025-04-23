import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/comment.dart';
import '../providers/firestore_comment_provider.dart';
import '../auth_serviices.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final String postId;
  final bool
  isPreview; // Flag to determine if this is a preview (limited functionality)

  const CommentCard({
    Key? key,
    required this.comment,
    required this.postId,
    this.isPreview = false,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool _isAdmin = false;
  bool _isAdminLoaded = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final isAdminUser = await AuthService.isAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = isAdminUser;
        _isAdminLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<FirestoreCommentProvider>(
      context,
      listen: false,
    );
    final theme = Theme.of(context);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final canDelete = _isAdmin || currentUserId == widget.comment.authorId;

    // Helper method to format timestamp
    String getTimeAgo() {
      return widget.comment.getTimeAgo();
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        radius: 16,
                        child: Text(
                          widget.comment.authorName.isNotEmpty
                              ? widget.comment.authorName[0].toUpperCase()
                              : 'A',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.comment.authorName.isNotEmpty
                                  ? widget.comment.authorName
                                  : 'Anonymous',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              getTimeAgo(),
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (canDelete && !widget.isPreview)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Delete Comment'),
                              content: const Text(
                                'Are you sure you want to delete this comment?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        await commentProvider.deleteComment(
                          widget.postId,
                          widget.comment.id,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Comment deleted')),
                        );
                      }
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Delete comment',
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(widget.comment.content, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            if (!widget.isPreview)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      commentProvider.toggleLike(
                        widget.postId,
                        widget.comment.id,
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: [
                          Icon(
                            widget.comment.isLikedByCurrentUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                widget.comment.isLikedByCurrentUser
                                    ? Colors.red
                                    : theme.iconTheme.color,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.comment.likes.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  widget.comment.isLikedByCurrentUser
                                      ? Colors.red
                                      : theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
