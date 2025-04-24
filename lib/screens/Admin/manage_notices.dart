import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/notice_provider.dart';

class ManageNoticesScreen extends StatefulWidget {
  final bool createNew;

  const ManageNoticesScreen({Key? key, this.createNew = false})
    : super(key: key);

  @override
  _ManageNoticesScreenState createState() => _ManageNoticesScreenState();
}

class _ManageNoticesScreenState extends State<ManageNoticesScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isEditing = false;
  String? _editingId;
  bool _isPinned = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Load notices from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoticeProvider>(context, listen: false).loadNotices().then((
        _,
      ) {
        setState(() {
          _isLoading = false;
        });
      });

      if (widget.createNew) {
        _showNoticeForm();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  TextStyle _archivoTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.archivo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 0.2,
    );
  }

  void _showNoticeForm({Map<String, dynamic>? notice}) {
    // Prepare for editing or creating
    _isEditing = notice != null;
    _editingId = notice?['id'];
    _titleController.text = notice?['title'] ?? '';
    _contentController.text = notice?['content'] ?? '';
    _isPinned = notice?['pinned'] ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                _isEditing ? 'Edit Notice' : 'Create Notice',
                style: _archivoTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _isPinned,
                          onChanged: (value) {
                            setDialogState(() {
                              _isPinned = value ?? false;
                            });
                          },
                          activeColor: Colors.red,
                        ),
                        Expanded(
                          child: Text(
                            'Pin this notice (important)',
                            style: _archivoTextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _titleController.clear();
                    _contentController.clear();
                    _isPinned = false;
                  },
                  child: Text(
                    'Cancel',
                    style: _archivoTextStyle(color: Colors.grey.shade700),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = _titleController.text.trim();
                    final content = _contentController.text.trim();
                    if (title.isEmpty || content.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    if (_isEditing) {
                      _updateNotice(title, content, _isPinned);
                    } else {
                      _createNotice(title, content, _isPinned);
                    }

                    Navigator.pop(context);
                    _titleController.clear();
                    _contentController.clear();
                    _isPinned = false;
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text(
                    _isEditing ? 'Update' : 'Create',
                    style: _archivoTextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _createNotice(String title, String content, bool pinned) {
    setState(() {
      _isLoading = true;
    });

    Provider.of<NoticeProvider>(context, listen: false)
        .addNotice(title, content, pinned)
        .then((_) {
          return Provider.of<NoticeProvider>(
            context,
            listen: false,
          ).loadNotices();
        })
        .then((_) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notice created successfully')),
          );
        });
  }

  void _updateNotice(String title, String content, bool pinned) {
    if (_editingId != null) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<NoticeProvider>(context, listen: false)
          .updateNotice(_editingId!, title, content, pinned)
          .then((_) {
            return Provider.of<NoticeProvider>(
              context,
              listen: false,
            ).loadNotices();
          })
          .then((_) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notice updated successfully')),
            );
          });
    }
  }

  void _deleteNotice(String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Notice'),
            content: Text('Are you sure you want to delete this notice?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  setState(() {
                    _isLoading = true;
                  });

                  Provider.of<NoticeProvider>(context, listen: false)
                      .deleteNotice(id)
                      .then((_) {
                        return Provider.of<NoticeProvider>(
                          context,
                          listen: false,
                        ).loadNotices();
                      })
                      .then((_) {
                        setState(() {
                          _isLoading = false;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Notice deleted successfully'),
                          ),
                        );
                      });
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Manage Notices',
          style: _archivoTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'ADMIN',
                  style: _archivoTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Consumer<NoticeProvider>(
                  builder: (context, noticeProvider, child) {
                    final notices = noticeProvider.notices;

                    if (notices.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.announcement_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No notices yet',
                              style: _archivoTextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Create your first notice by tapping the + button below',
                              textAlign: TextAlign.center,
                              style: _archivoTextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: notices.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12),
                      itemBuilder:
                          (_, index) => _buildNoticeCard(notices[index]),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoticeForm(),
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Create Notice',
      ),
    );
  }

  Widget _buildNoticeCard(Notice notice) {
    return Container(
      decoration: BoxDecoration(
        color: notice.isPinned ? Colors.red.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notice.isPinned ? Colors.red.shade200 : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:
                  notice.isPinned ? Colors.red.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                if (notice.isPinned) ...[
                  Icon(Icons.push_pin, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    notice.title,
                    style: _archivoTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          notice.isPinned
                              ? Colors.red.shade900
                              : Colors.black87,
                    ),
                  ),
                ),
                Text(
                  notice.createdAt.toIso8601String().substring(0, 10),
                  style: _archivoTextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              notice.content,
              style: _archivoTextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Divider(
            height: 1,
            color: notice.isPinned ? Colors.red.shade100 : Colors.grey.shade300,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _showNoticeForm(notice: notice.toMap()),
                  icon: Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () => _deleteNotice(notice.id),
                  icon: Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
