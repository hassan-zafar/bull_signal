import 'dart:convert';

import 'package:bull_signal/Models/users.dart';
import 'package:bull_signal/Utils/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DatabaseMethod {
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
