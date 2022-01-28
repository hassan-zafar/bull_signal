import 'package:bull_signal/Screens/credentials/loginRelated/login_page.dart';
import 'package:bull_signal/Screens/credentials/signUpRelated/signup_page.dart';
import 'package:flutter/material.dart';

buildSignUpLoginButton(
    {required BuildContext context,
    required String btnText,
    required String assetImage,
    bool hasIcon = false,
    double fontSize = 20,
    Color color = Colors.white,
    double leftRightPadding = 20.0,
    textColor = Colors.black}) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      //  opacity: 0.6,
      // padding: EdgeInsets.all(8),
      // color: color,
      // intensity: 0.35,
      // style: NeuomorphicStyle.Concave,
      // borderRadius: BorderRadius.circular(20),
      child: hasIcon
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 8, bottom: 8),
                  child: Image.asset(
                    assetImage,
                    height: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    btnText,
                    style: TextStyle(
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  btnText,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
    ),
  );
}

buildSignUpLoginText(
    {required BuildContext context,
    required String text1,
    required String text2,
    required bool moveToLogIn}) {
  return Container(
    color: Colors.transparent,
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text1,
              style: const TextStyle(
                fontSize: 15.0,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          moveToLogIn ? LoginPage() : const SignUpPage())),
              child: Text(
                text2,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        )),
  );
}
