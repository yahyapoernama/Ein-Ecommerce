import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<void> _logout() async {
    var box = await Hive.openBox('userBox');
    await box.clear(); // Hapus semua data sesi

    if (!mounted) return; // Periksa apakah widget masih terpasang

    // Arahkan pengguna ke halaman login
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog tidak bisa ditutup dengan menekan di luar dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.redAccent,
              ),
              SizedBox(width: 10),
              Text(
                'Confirm Logout',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: const Text('Are you sure you want to logout?'),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _logout(); // Panggil fungsi logout
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0, bottom: 15.0, top: 10),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/sample/profile1.webp'), // Replace with user's photo URL
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Name', // Replace with user's name
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'user@example.com', // Replace with user's email
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Account'),
                    onTap: () {
                      // Navigate to account settings
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    onTap: () {
                      // Navigate to notification settings
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Privacy'),
                    onTap: () {
                      // Navigate to privacy settings
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help & Support'),
                    onTap: () {
                      // Navigate to help & support
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    onTap: () {
                      // Navigate to about
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tileColor: Colors.redAccent.withOpacity(0.1),
                    onTap: () => _showLogoutConfirmationDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
