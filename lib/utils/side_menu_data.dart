import 'package:coach_web/model/menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.dashboard, title: 'Dashboard'),
    MenuModel(icon: Icons.run_circle, title: 'Pemain'),
    MenuModel(icon: Icons.category, title: 'Aspek'),
    MenuModel(icon: Icons.assignment, title: 'Kriteria'),
    MenuModel(icon: Icons.bar_chart, title: 'Statistik'),
    MenuModel(icon: Icons.emoji_emotions, title: 'Emotional'),
    MenuModel(icon: Icons.people, title: 'Line Up'),
    MenuModel(icon: Icons.score, title: 'Hasil Penilaian'),
    MenuModel(icon: Icons.logout, title: 'SignOut'),
  ];
}
