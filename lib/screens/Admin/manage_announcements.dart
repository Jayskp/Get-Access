import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ManageAnnouncementsScreen extends StatefulWidget {
  final bool createNew;

  const ManageAnnouncementsScreen({Key? key, this.createNew = false})
      : super(key: key);

  @override
  _ManageAnnouncementsScreenState createState() =>
      _ManageAnnouncementsScreenState();
}

class _ManageAnnouncementsScreenState extends State<ManageAnnouncementsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  List<Map<String, dynamic>> announcements = [
    {
      'id': '1',
      'title': 'Annual General Meeting',
      'content': 'Discussion on annual budget and infrastructure improvements.',
      'date': '2024-07-15',
      'time': '18:00',
      'location': 'Community Hall',
      'featured': true,
    },
    {
      'id': '2',
      'title': 'Summer Festival',
      'content':
      'Join us for games, food, and entertainment. All residents welcome!',
      'date': '2024-07-25',
      'time': '10:00',
      'location': 'Community Garden',
      'featured': true,
    },
    {
      'id': '3',
      'title': 'Maintenance Workshop',
      'content': 'Learn basic home maintenance tips from our maintenance team.',
      'date': '2024-07-10',
      'time': '16:30',
      'location': 'Block B Meeting Room',
      'featured': false,
    },
  ];

  bool _isEditing = false;
  String? _editingId;
  bool _isFeatured = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.createNew) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAnnouncementForm();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 12),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _timeController.text =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _showAnnouncementForm({Map<String, dynamic>? announcement}) {
    setState(() {
      _isEditing = announcement != null;
      _editingId = announcement?['id'];
      _titleController.text = announcement?['title'] ?? '';
      _contentController.text = announcement?['content'] ?? '';
      _dateController.text = announcement?['date'] ?? '';
      _timeController.text = announcement?['time'] ?? '';
      _locationController.text = announcement?['location'] ?? '';
      _isFeatured = announcement?['featured'] ?? false;

      if (announcement?['date'] != null) {
        _selectedDate = DateTime.parse(announcement!['date']);
      } else {
        _selectedDate = null;
      }
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            title: Text(
              _isEditing ? 'Edit Announcement' : 'Create Announcement',
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
                    maxLines: 4,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _timeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Time',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () => _selectTime(context),
                      ),
                    ),
                    onTap: () => _selectTime(context),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _isFeatured,
                        onChanged: (value) {
                          // Update the state directly within the dialog
                          setDialogState(() {
                            _isFeatured = value ?? false;
                          });
                          // Also update parent state
                          setState(() {
                            _isFeatured = value ?? false;
                          });
                        },
                        activeColor: Colors.red,
                      ),
                      Text(
                        'Feature this announcement',
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
                  _clearForm();
                },
                child: Text(
                  'Cancel',
                  style: _archivoTextStyle(color: Colors.grey.shade700),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty ||
                      _contentController.text.isEmpty ||
                      _dateController.text.isEmpty ||
                      _timeController.text.isEmpty ||
                      _locationController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  if (_isEditing) {
                    _updateAnnouncement();
                  } else {
                    _createAnnouncement();
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
          );
        },
      ),
    );
  }

  void _clearForm() {
    setState(() {
      _titleController.clear();
      _contentController.clear();
      _dateController.clear();
      _timeController.clear();
      _locationController.clear();
      _isFeatured = false;
      _selectedDate = null;
    });
  }

  void _createAnnouncement() {
    final newAnnouncement = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleController.text,
      'content': _contentController.text,
      'date': _dateController.text,
      'time': _timeController.text,
      'location': _locationController.text,
      'featured': _isFeatured,
    };

    setState(() {
      announcements.add(newAnnouncement);
      _clearForm();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Announcement created successfully')),
    );
  }

  void _updateAnnouncement() {
    final index = announcements.indexWhere(
          (announcement) => announcement['id'] == _editingId,
    );
    if (index != -1) {
      setState(() {
        announcements[index] = {
          'id': _editingId,
          'title': _titleController.text,
          'content': _contentController.text,
          'date': _dateController.text,
          'time': _timeController.text,
          'location': _locationController.text,
          'featured': _isFeatured,
        };
        _clearForm();
        _editingId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Announcement updated successfully')),
      );
    }
  }

  void _deleteAnnouncement(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Announcement'),
        content: Text('Are you sure you want to delete this announcement?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                announcements.removeWhere(
                      (announcement) => announcement['id'] == id,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Announcement deleted successfully'),
                ),
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
    // Sort announcements: featured first, then by date
    final sortedAnnouncements = [...announcements];
    sortedAnnouncements.sort((a, b) {
      if (a['featured'] && !b['featured']) return -1;
      if (!a['featured'] && b['featured']) return 1;
      return a['date'].compareTo(b['date']);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Manage Announcements',
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
        child: sortedAnnouncements.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_note,
                size: 80,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 16),
              Text(
                'No announcements yet',
                style: _archivoTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Create your first announcement by tapping the + button below',
                textAlign: TextAlign.center,
                style: _archivoTextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        )
            : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: sortedAnnouncements.length,
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final announcement = sortedAnnouncements[index];
            return _buildAnnouncementCard(announcement);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAnnouncementForm(),
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Create Announcement',
      ),
    );
  }

  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
    // Parse the date and format it for display
    final DateTime date = DateTime.parse(announcement['date']);
    final String formattedDate = DateFormat('EEE, MMM d, yyyy').format(date);

    return Container(
      decoration: BoxDecoration(
        color: announcement['featured']
            ? Colors.amber.shade50
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: announcement['featured']
              ? Colors.amber.shade300
              : Colors.grey.shade300,
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
              color: announcement['featured']
                  ? Colors.amber.shade100
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    announcement['title'],
                    style: _archivoTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: announcement['featured']
                          ? Colors.orange.shade900
                          : Colors.black87,
                    ),
                  ),
                ),
                if (announcement['featured'])
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Featured',
                      style: _archivoTextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement['content'],
                  style: _archivoTextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 16),
                _buildInfoRow(Icons.calendar_today, formattedDate),
                SizedBox(height: 8),
                _buildInfoRow(Icons.access_time, announcement['time']),
                SizedBox(height: 8),
                _buildInfoRow(Icons.location_on, announcement['location']),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: announcement['featured']
                ? Colors.amber.shade200
                : Colors.grey.shade300,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _showAnnouncementForm(announcement: announcement),
                  icon: Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () => _deleteAnnouncement(announcement['id']),
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        SizedBox(width: 8),
        Text(
          text,
          style: _archivoTextStyle(fontSize: 14, color: Colors.grey.shade800),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}