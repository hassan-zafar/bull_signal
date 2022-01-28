import 'package:bull_signal/Models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final announcementsRef = FirebaseFirestore.instance.collection('announcements');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final chatRoomRef = FirebaseFirestore.instance.collection('chatRoom');
final chatListRef = FirebaseFirestore.instance.collection('chatLists');

AppUserModel? currentUser;
TextStyle titleTextStyle({double fontSize = 25, Color color = Colors.black}) {
  return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 1.8);
}
