import 'package:coach_web/config/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:coach_web/feature/cobalogin.dart';

Future<void> signOut(BuildContext context) async {
  bool confirm = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false
            },
          ),
          TextButton(
            child: Text('Logout'),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true
            },
          ),
        ],
      );
    },
  );

  if (confirm) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user');

    // Clear UserProvider
    Provider.of<UserProvider>(context, listen: false).setUser(null);

    // Navigate to LoginScreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
