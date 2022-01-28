import 'dart:convert';

import 'package:bull_signal/Models/users.dart';
import 'package:bull_signal/Utils/consts.dart';
import 'package:bull_signal/tools/custom_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DatabaseMethods {  addUserInfoToFirebase({
    required final String password,
    required final String? name,
    required final String? joinedAt,
    required final int? phoneNo,
    required final String? imageUrl,
    required final Timestamp? createdAt,
    required final String email,
    required final String userId,
    final bool? isAdmin,
  }) {
    print("addUserInfoToFirebase");
    return userRef.doc(userId).set({
      'id': userId,
      'name': name,
      'phoneNo': phoneNo,
      'password': password,
      'createdAt': createdAt,
      'isAdmin': isAdmin,
      'email': email,
      'joinedAt': joinedAt,
      'imageUrl': imageUrl,
      'androidNotificationToken': "",
    }).then((value) {
      // currentUser = userModel;
    }).catchError(
      (Object obj) {
        errorToast(message: obj.toString());
      },
    );
  }
  Future fetchUserInfoFromFirebase({
    required String uid,
  }) async {
    final DocumentSnapshot _user = await userRef.doc(uid).get();
    currentUser = AppUserModel.fromDocument(_user);
    createToken(uid);
    Map userData = json.decode(currentUser!.toJson());
    // UserLocalData().setUserModel(json.encode(userData));
    // print(user);
    print(currentUser!.email);
  }

  createToken(String uid) {
    FirebaseMessaging.instance.getToken().then((token) {
      userRef.doc(uid).update({
        "androidNotificationToken": token,
      });
      // UserLocalData().setToken(token!);
    });
  }
}
