import 'package:bull_signal/Database/database.dart';
import 'package:bull_signal/Screens/credentials/loginRelated/login_page.dart';
import 'package:bull_signal/Utils/consts.dart';
import 'package:bull_signal/announcements/announcements.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        // ignore: missing_return
        builder: (context, AsyncSnapshot<User?> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (userSnapshot.connectionState == ConnectionState.active) {
            if (userSnapshot.hasData) {
              print('userSnapshot.hasData ${userSnapshot.hasData}');
              uid = userSnapshot.data!.uid;
              DatabaseMethods()
                  .fetchUserInfoFromFirebase(uid: userSnapshot.data!.uid)
                  .then((value) {
                print('The user is already logged in');
                return Announcements();
              });

              // MainScreens();
            } else {
              print('The user didn\'t login yet');
              return
                  // IntroductionAuthScreen();
                  LoginPage();
            }
          } else if (userSnapshot.hasError) {
            return const Center(
              child: Text('Error occured'),
            );
          } else {
            return const Center(
              child: Text('Error occured'),
            );
          }
        });
  }
}
