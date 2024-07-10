import 'package:flutter/material.dart';

class MenuModel {
  final IconData? icon;
  final String? iconPath;
  final String title;

  const MenuModel({this.icon, this.iconPath, required this.title})
      : assert(icon != null || iconPath != null,
            'Either icon or iconPath must be provided');
}
