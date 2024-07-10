import 'package:coach_web/config/user_provider.dart';
import 'package:coach_web/utils/constant.dart';
import 'package:coach_web/utils/side_menu_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coach_web/feature/cobalogin.dart';

class SideMenuWidget extends StatefulWidget {
  final Function(int) onMenuItemClicked;

  const SideMenuWidget({super.key, required this.onMenuItemClicked});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      color: const Color(0xFF171821),
      child: Column(
        children: [
          // Add your logo here
          Container(
            child: Image.asset('assets/images/logo_white.png',
                width: 200, height: 200), // Modify path to your logo
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.menu.length,
              itemBuilder: (context, index) => buildMenuEntry(data, index),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(6.0),
        ),
        color: isSelected ? selectionColor : Colors.transparent,
      ),
      child: InkWell(
        onTap: () {
          if (index == 7) {
            // Index 7 is for SignOut
            signOut(context);
          } else {
            setState(() {
              selectedIndex = index;
            });
            widget.onMenuItemClicked(
                index); // Call the callback to update the main screen
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              child: Icon(
                data.menu[index].icon,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
            Text(
              data.menu[index].title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
