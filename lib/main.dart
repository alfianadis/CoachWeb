import 'package:coach_web/feature/cobalogin.dart';
import 'package:coach_web/feature/cobaregis.dart';
import 'package:coach_web/feature/login_screen.dart';
import 'package:coach_web/feature/main_screen.dart';
import 'package:coach_web/utils/constant.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashborad UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        brightness: Brightness.dark,
      ),
      home: MainScreen(),
      // routes: {
      //   '/login': (context) => LoginScreen(),
      //   '/register': (context) => RegisterScreen(),
      //   '/main': (context) => MainScreen(),
      // },
    );
  }
}
