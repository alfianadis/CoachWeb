import 'package:coach_web/model/menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard'),
    MenuModel(icon: Icons.run_circle, title: 'Pemain'),
    MenuModel(icon: Icons.person, title: 'Aspek'),
    MenuModel(icon: Icons.person, title: 'Kriteria'),
    MenuModel(icon: Icons.person, title: 'Statistik'),
    MenuModel(icon: Icons.settings, title: 'Line Up'),
    MenuModel(icon: Icons.history, title: 'Hasil Penilaian'),
    MenuModel(icon: Icons.logout, title: 'SignOut'),
  ];
}
