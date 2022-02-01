import 'package:bull_signal/Models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final announcementsRef = FirebaseFirestore.instance.collection('announcements');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final chatRoomRef = FirebaseFirestore.instance.collection('chatRoom');
final chatListRef = FirebaseFirestore.instance.collection('chatLists');

const String logo = 'assets/images/logo.jpeg';
// const String logout = 'assets/images/logOut.svg';

// const String loginIcon = 'assets/images/logIn.svg';
// const String signUp = 'assets/images/signUp.svg';
AppUserModel? currentUser;
String? uid;

TextStyle titleTextStyle({double fontSize = 25, Color? color = Colors.white}) {
  return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 1.8);
}

TextStyle customTextStyle(
    {FontWeight fontWeight = FontWeight.w300,
    double fontSize = 25,
    Color color = Colors.white}) {
  return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 3);
}
