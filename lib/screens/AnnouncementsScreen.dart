import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth_serviices.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final isAdminUser = await AuthService.isAdmin();
    setState(() {
      _isAdmin = isAdminUser;
    });
  }

  Future<void> _addAnnouncement() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('announcements').add({
        'title': _titleController.text,
        'content': _contentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _contentController.clear();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement added successfully')),
      );
    } catch (e) {
      if (!mounted) return;

      String errorMessage = 'Error adding announcement';

      // Special handling for missing Firestore database
      if (e.toString().contains('database (default) does not exist')) {
        errorMessage =
            'Firestore database not set up. Please set up Firestore in Firebase console.';
      } else {
        errorMessage = 'Error adding announcement: $e';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  Future<void> _deleteAnnouncement(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('announcements')
          .doc(docId)
          .delete();

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Announcement deleted')));
    } catch (e) {
      if (!mounted) return;

      String errorMessage = 'Error deleting announcement';

      // Special handling for missing Firestore database
      if (e.toString().contains('database (default) does not exist')) {
        errorMessage =
            'Firestore database not set up. Please set up Firestore in Firebase console.';
      } else {
        errorMessage = 'Error deleting announcement: $e';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: Column(
        children: [
          // Admin input section
          if (_isAdmin)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Announcement Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Announcement Content',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _addAnnouncement,
                    child: const Text('Post Announcement'),
                  ),
                  const Divider(height: 32),
                ],
              ),
            ),

          // Announcements list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('announcements')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                // Handle Firestore database error
                if (snapshot.hasError) {
                  String errorMessage = 'Error: ${snapshot.error}';

                  // Special handling for missing Firestore database
                  if (snapshot.error.toString().contains(
                    'database (default) does not exist',
                  )) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Firestore Database Not Set Up',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'You need to set up Firestore in the Firebase console to use this feature.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            if (_isAdmin)
                              ElevatedButton.icon(
                                onPressed: () {
                                  // This is a placeholder for navigation to a help screen
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please visit Firebase console to set up Firestore',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.help_outline),
                                label: const Text('Setup Instructions'),
                              ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Center(child: Text(errorMessage));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final announcements = snapshot.data?.docs ?? [];

                if (announcements.isEmpty) {
                  return const Center(child: Text('No announcements yet'));
                }

                return ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = announcements[index];
                    final data = announcement.data() as Map<String, dynamic>;
                    final title = data['title'] ?? 'No Title';
                    final content = data['content'] ?? 'No Content';
                    final timestamp = data['timestamp'] as Timestamp?;
                    final date =
                        timestamp != null
                            ? DateTime.fromMillisecondsSinceEpoch(
                              timestamp.millisecondsSinceEpoch,
                            )
                            : DateTime.now();

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: ListTile(
                        title: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(content),
                            const SizedBox(height: 8),
                            Text(
                              'Posted on: ${date.day}/${date.month}/${date.year}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing:
                            _isAdmin
                                ? IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed:
                                      () =>
                                          _deleteAnnouncement(announcement.id),
                                )
                                : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
