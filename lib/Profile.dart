import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _avatarBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAvatar() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _avatarBytes = bytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final avatarRadius = width * 0.15;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 0, bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.lightGreen.shade200.withOpacity(0.1),
                    Colors.yellow.shade600.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _avatarBytes != null
                          ? MemoryImage(_avatarBytes!)
                          : null,
                      child: _avatarBytes == null
                          ? Text(
                        'D',
                        style: TextStyle(
                          fontSize: avatarRadius * 0.8,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Dhruv',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'dhruv@gmail.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Icon buttons row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconButton(Icons.account_balance_wallet, 'Payment'),
                  _iconButton(Icons.settings, 'Settings'),
                  _iconButton(Icons.notifications, 'Notification'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Details card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _infoRow('Password', 'Change', true),
                    _divider(),
                    _infoRow('Mobile', '1234-123-9874', false),
                    _divider(),
                    _infoRow('Tel', '1234-123-9874', false),
                    _divider(),
                    _infoRow('Address', 'NY- Street 21-no 34', false),
                    _divider(),
                    _infoRow('Postal Code', '9871234567', false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Edit button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {},
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 28, color: Colors.lightGreen.shade700),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _infoRow(String title, String value, bool actionable) {
    return InkWell(
      onTap: actionable ? () {} : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: actionable
                    ? Colors.lightGreen.shade700
                    : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Container(
    height: 1,
    color: Colors.grey.shade200,
  );
}
