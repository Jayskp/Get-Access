import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  List<Map<String, dynamic>> notices = [
    {
      'id': '1',
      'title': 'Water Supply Interruption',
      'content':
          'Water supply will be interrupted on Sunday from 10 AM to 2 PM due to maintenance work.',
      'date': '2024-06-15',
      'pinned': true,
    },
    {
      'id': '2',
      'title': 'Society Meeting Notice',
      'content':
          'Annual society meeting will be held on June 20th at 7 PM in the community hall.',
      'date': '2024-06-10',
      'pinned': false,
    },
    {
      'id': '3',
      'title': 'Fire Drill Practice',
      'content':
          'Monthly fire drill practice will be conducted on June 18th at 11 AM. All residents are requested to participate.',
      'date': '2024-06-08',
      'pinned': false,
    },
  ];

  bool _isEditing = false;
  String? _editingId;
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    if (widget.createNew) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNoticeForm();
      });
    }
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
    setState(() {
      _isEditing = notice != null;
      _editingId = notice?['id'];
      _titleController.text = notice?['title'] ?? '';
      _contentController.text = notice?['content'] ?? '';
      _isPinned = notice?['pinned'] ?? false;
    });

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
                          setState(() {
                            _isPinned = value ?? false;
                          });
                          Navigator.pop(context);
                          _showNoticeForm(
                            notice:
                                notice != null
                                    ? {...notice, 'pinned': _isPinned}
                                    : null,
                          );
                        },
                        activeColor: Colors.red,
                      ),
                      Text(
                        'Pin this notice (important)',
                        style: _archivoTextStyle(fontSize: 14),
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
                  setState(() {
                    _titleController.clear();
                    _contentController.clear();
                    _isPinned = false;
                  });
                },
                child: Text(
                  'Cancel',
                  style: _archivoTextStyle(color: Colors.grey.shade700),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty ||
                      _contentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  if (_isEditing) {
                    _updateNotice();
                  } else {
                    _createNotice();
                  }

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  _isEditing ? 'Update' : 'Create',
                  style: _archivoTextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _createNotice() {
    final newNotice = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleController.text,
      'content': _contentController.text,
      'date': DateTime.now().toString().substring(0, 10),
      'pinned': _isPinned,
    };

    setState(() {
      notices.add(newNotice);
      _titleController.clear();
      _contentController.clear();
      _isPinned = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Notice created successfully')));
  }

  void _updateNotice() {
    final index = notices.indexWhere((notice) => notice['id'] == _editingId);
    if (index != -1) {
      setState(() {
        notices[index] = {
          'id': _editingId,
          'title': _titleController.text,
          'content': _contentController.text,
          'date': notices[index]['date'],
          'pinned': _isPinned,
        };
        _titleController.clear();
        _contentController.clear();
        _isPinned = false;
        _editingId = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Notice updated successfully')));
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
                  setState(() {
                    notices.removeWhere((notice) => notice['id'] == id);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notice deleted successfully')),
                  );
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sort notices: pinned first, then by date
    final sortedNotices = [...notices];
    sortedNotices.sort((a, b) {
      if (a['pinned'] && !b['pinned']) return -1;
      if (!a['pinned'] && b['pinned']) return 1;
      return b['date'].compareTo(a['date']);
    });

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
            sortedNotices.isEmpty
                ? Center(
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
                        style: _archivoTextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
                : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedNotices.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final notice = sortedNotices[index];
                    return _buildNoticeCard(notice);
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

  Widget _buildNoticeCard(Map<String, dynamic> notice) {
    return Container(
      decoration: BoxDecoration(
        color: notice['pinned'] ? Colors.red.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notice['pinned'] ? Colors.red.shade200 : Colors.grey.shade300,
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
                  notice['pinned'] ? Colors.red.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (notice['pinned']) ...[
                        Icon(Icons.push_pin, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                      ],
                      Text(
                        notice['title'],
                        style: _archivoTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              notice['pinned']
                                  ? Colors.red.shade900
                                  : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  notice['date'],
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
              notice['content'],
              style: _archivoTextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Divider(
            height: 1,
            color:
                notice['pinned'] ? Colors.red.shade100 : Colors.grey.shade300,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _showNoticeForm(notice: notice),
                  icon: Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () => _deleteNotice(notice['id']),
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

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
