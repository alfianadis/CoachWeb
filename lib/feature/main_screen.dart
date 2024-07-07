import 'package:coach_web/components/side_menu_widget.dart';
import 'package:coach_web/config/responsive.dart';
import 'package:coach_web/feature/dashboard.dart';
import 'package:coach_web/feature/lineup_screen.dart';
import 'package:coach_web/feature/pemain_screen.dart';
import 'package:coach_web/feature/result_assessment_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Responsive.isMobile(context)
          ? Drawer(
              child: SideMenuWidget(
                onMenuItemClicked: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                  Navigator.of(context)
                      .pop(); // Close the drawer after selecting an item
                },
              ),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (!Responsive.isMobile(context))
              Container(
                width: Responsive.isDesktop(context)
                    ? 250
                    : 200, // Adjust width for desktop and tablet
                child: SideMenuWidget(
                  onMenuItemClicked: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            Expanded(
              flex: Responsive.isDesktop(context) ? 7 : 5,
              child: IndexedStack(
                index: currentIndex,
                children: [
                  LineupScreen(),

                  DashboardScreen(),
                  // ScheduleScreen(),
                  PemainScreen(),
                  HasilPenilaianScreen(),
                  // SignOutPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
