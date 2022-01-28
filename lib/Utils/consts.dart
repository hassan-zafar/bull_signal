import 'package:bull_signal/Models/users.dart';
import 'package:flutter/material.dart';

AppUserModel? currentUser;
TextStyle titleTextStyle({double fontSize = 25, Color color = Colors.black}) {
  return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 1.8);
}
