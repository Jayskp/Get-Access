import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _coverImage;
  File? _avatarImage;
  bool _callingEnabled = false;

  final Map<String, dynamic> _user = {
    'name': 'Swati Patel',
    'flat': 'B-1204',
    'role': 'Tenant',
    'bio': '',
    'work': '',
    'hometown': '',
    'interests': <String>[]
  };

  Future<void> _pickImage(bool cover) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() {
      if (cover) _coverImage = File(picked.path);
      else _avatarImage = File(picked.path);
    });
  }

  void _editField(String key, String label, {bool isList = false}) {
    final controller = TextEditingController(
      text: isList ? _user[key].join(', ') : _user[key].toString(),
    );
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: label),
              maxLines: isList ? 1 : null,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isList) {
                    _user[key] = controller.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();
                  } else {
                    _user[key] = controller.text;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bannerHeight = constraints.maxHeight * 0.3;
          const avatarRadius = 40.0;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Banner
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: bannerHeight,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightGreen.shade200, Colors.yellow.shade200],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: _coverImage != null
                      ? Image.file(_coverImage!, fit: BoxFit.cover, width: double.infinity)
                      : null,
                ),
              ),
              // White panel behind avatar
              Positioned(
                top: bannerHeight - avatarRadius / 2,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, avatarRadius + 20, 20, 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _user['name'],
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                const Text('Enable calling', style: TextStyle(color: Colors.grey)),
                                Switch(
                                  activeColor: Colors.lightGreen.shade600,
                                  value: _callingEnabled,
                                  onChanged: (v) => setState(() => _callingEnabled = v),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.apartment, size: 18, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(_user['flat'], style: const TextStyle(color: Colors.grey)),
                            const SizedBox(width: 16),
                            const Icon(Icons.home, size: 18, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(_user['role'], style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(_user['bio'].isEmpty ? 'Add Bio' : _user['bio']),
                          subtitle: const Text('Tell your neighbours about yourself', style: TextStyle(color: Colors.grey)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _editField('bio', 'Bio'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.work_outline, color: Colors.grey),
                          title: Text(_user['work'].isEmpty ? 'Add Work' : _user['work']),
                          onTap: () => _editField('work', 'Work'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
                          title: Text(_user['hometown'].isEmpty ? 'Add Hometown' : _user['hometown']),
                          onTap: () => _editField('hometown', 'Hometown'),
                        ),
                        const SizedBox(height: 20),
                        const Text('Interests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () => _editField('interests', 'Interests', isList: true),
                          icon: Icon(Icons.add, color: Colors.lightGreen.shade800),
                          label: Text('Add Interests', style: TextStyle(color: Colors.lightGreen.shade800)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.lightGreen.shade600),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              // Banner camera icon
              Positioned(
                top: 40,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () => _pickImage(true),
                  ),
                ),
              ),
              // Avatar on top
              Positioned(
                top: constraints.maxHeight * 0.3 - avatarRadius,
                left: 20,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: Colors.white,
                      backgroundImage: _avatarImage != null ? FileImage(_avatarImage!) : null,
                      child: _avatarImage == null
                          ? Text(
                        _user['name'][0],
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.lightGreen.shade800),
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.lightGreen.shade800,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                          onPressed: () => _pickImage(false),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
