import 'dart:convert';

import 'package:coach_web/config/user_provider.dart';
import 'package:coach_web/feature/cobalogin.dart';
import 'package:coach_web/feature/main_screen.dart';
import 'package:coach_web/model/auth_response.dart';
import 'package:coach_web/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Periksa status login
  final prefs = await SharedPreferences.getInstance();
  final userJson = prefs.getString('user');
  User? user;

  if (userJson != null) {
    user = User.fromJson(jsonDecode(userJson));
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(initialUser: user),
    ),
  );
}

class MyApp extends StatelessWidget {
  final User? initialUser;

  const MyApp({super.key, this.initialUser});

  @override
  Widget build(BuildContext context) {
    // Set initial user in UserProvider
    if (initialUser != null) {
      Provider.of<UserProvider>(context, listen: false).setUser(initialUser!);
    }

    return MaterialApp(
      title: 'Dashboard UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        brightness: Brightness.dark,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id'), // Bahasa Indonesia
      ],
      home: initialUser == null ? LoginScreen() : MainScreen(),
      // routes: {
      //   '/login': (context) => LoginScreen(),
      //   '/register': (context) => RegisterScreen(),
      //   '/main': (context) => MainScreen(),
      // },
    );
  }
}
