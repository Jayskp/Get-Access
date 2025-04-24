import 'package:flutter/material.dart';
import 'package:getaccess/providers/announcement_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  bool _isEditing = false;
  String? _editingId;
  bool _isFeatured = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    // Load initial data
    Provider.of<AnnouncementProvider>(
      context,
      listen: false,
    ).loadAnnouncements();

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
      builder:
          (context) => StatefulBuilder(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
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
    final provider = Provider.of<AnnouncementProvider>(context, listen: false);

    provider
        .addAnnouncement(
          _titleController.text,
          _contentController.text,
          _isFeatured,
        )
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Announcement created successfully')),
          );
          _clearForm();
        });
  }

  void _updateAnnouncement() {
    if (_editingId != null) {
      Provider.of<AnnouncementProvider>(context, listen: false)
          .updateAnnouncement(
            _editingId!,
            _titleController.text,
            _contentController.text,
            _isFeatured,
          )
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Announcement updated successfully')),
            );
            _clearForm();
          });
    }
  }

  void _deleteAnnouncement(String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Announcement'),
            content: Text('Are you sure you want to delete this announcement?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<AnnouncementProvider>(
                    context,
                    listen: false,
                  ).deleteAnnouncement(id).then((_) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Announcement deleted successfully'),
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
        child: Consumer<AnnouncementProvider>(
          builder: (context, provider, child) {
            final announcements = provider.announcements;

            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (announcements.isEmpty) {
              return Center(
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
              );
            }

            // Sort announcements
            final sortedAnnouncements = [...announcements];
            sortedAnnouncements.sort((a, b) {
              if (a.isImportant && !b.isImportant) return -1;
              if (!a.isImportant && b.isImportant) return 1;
              return b.createdAt.compareTo(a.createdAt);
            });

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sortedAnnouncements.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildAnnouncementCard(sortedAnnouncements[index]);
              },
            );
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

  Widget _buildAnnouncementCard(Announcement announcement) {
    // Parse the date and format it for display
    final String formattedDate = DateFormat('EEE, MMM d, yyyy').format(announcement.createdAt);

    return Container(
      decoration: BoxDecoration(
        color: announcement.isImportant ? Colors.amber.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: announcement.isImportant ? Colors.amber.shade300 : Colors.grey.shade300,
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
              color: announcement.isImportant ? Colors.amber.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    announcement.title,
                    style: _archivoTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: announcement.isImportant ? Colors.orange.shade900 : Colors.black87,
                    ),
                  ),
                ),
                if (announcement.isImportant)
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
                  announcement.content,
                  style: _archivoTextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 16),
                _buildInfoRow(Icons.calendar_today, formattedDate),
                // Remove or modify these lines if the properties don't exist
                // SizedBox(height: 8),
                // _buildInfoRow(Icons.access_time, announcement.time),
                // SizedBox(height: 8),
                // _buildInfoRow(Icons.location_on, announcement.location),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: announcement.isImportant ? Colors.amber.shade200 : Colors.grey.shade300,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _showAnnouncementForm(
                    announcement: <String, dynamic>{
                      'id': announcement.id,
                      'title': announcement.title,
                      'content': announcement.content,
                      'date': DateFormat('yyyy-MM-dd').format(announcement.createdAt),
                      'featured': announcement.isImportant,
                      // Don't include properties that don't exist in Announcement class
                    },
                  ),
                  icon: Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () => _deleteAnnouncement(announcement.id),
                  icon: Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }  Widget _buildInfoRow(IconData icon, String text) {
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
