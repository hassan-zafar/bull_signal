import 'package:bull_signal/Services/authentication_service.dart';
import 'package:bull_signal/Utils/commonWidgets.dart';
import 'package:bull_signal/Utils/consts.dart';
import 'package:bull_signal/Utils/palette.dart';
import 'package:bull_signal/announcements/announcements.dart';
import 'package:bull_signal/tools/custom_toast.dart';
import 'package:bull_signal/tools/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscureText = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  // TextEditingController _addressController = TextEditingController();
  final _textFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _textFormKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Hero(
                            tag: "logo",
                            child: Image.asset(
                              logo,
                              height: 90,
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      edittedTextField(
                        hintText: "Enter a valid user name, min length 6",
                        controller: _userNameController,
                        isPass: false,
                        lablelText: "Username",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      edittedTextField(
                        hintText: "Enter a valid email address",
                        controller: _emailController,
                        isPass: false,
                        isEmail: true,
                        lablelText: "Email Address",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      edittedTextField(
                        hintText: "Enter a valid password, min length 6",
                        valText: 'Password Too Short',
                        controller: _passwordController,
                        isPass: true,
                        lablelText: "Password",
                        obscureText: _obscureText,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      edittedTextField(
                        hintText: "Enter same password as above",
                        valText: 'Password Too Short',
                        controller: _confirmPasswordController,
                        isPass: true,
                        lablelText: "Confirm Password",
                        obscureText: _obscureText,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      edittedTextField(
                        hintText: "Enter a valid phone number",
                        controller: _phoneNoController,
                        isPass: false,
                        valText: 'Phone number Too Short',
                        lablelText: "Phone Number",
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => _handleSignUp(context),
                          child: buildSignUpLoginButton(
                              context: context,
                              btnText: "Sign Up",
                              assetImage: logo,
                              // color: containerColor,
                              hasIcon: false),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
// Move to Sign Up Page
                    ],
                  ),
                ),
              ),
            ),
            _isLoading ? const LoadingIndicator() : Container(),
          ],
        ),
        bottomSheet: buildSignUpLoginText(
            context: context,
            text1: "Already Have an account ",
            text2: "Sign In",
            moveToLogIn: true),
      ),
    );
  }

  emailValidation(val) {
    if (val == null) {
      return null;
    }
    if (val.isEmpty) {
      return "Field is Empty";
    } else if (!val.contains("@") || val.trim().length < 4) {
      return "Invalid E-mail!";
    } else {
      return null;
    }
  }

  Container edittedTextField({
    String? lablelText,
    String? hintText,
    bool? isEmail = false,
    bool? obscureText = true,
    String? valText,
    int valLength = 6,
    TextEditingController? controller,
    bool? isPass,
  }) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12.0,
        ),
        child: TextFormField(
          obscureText: isPass! ? true : false,
          validator: (val) {
            if (!isEmail!) {
              if (val == null) {
                return null;
              }
              if (val.length < valLength) {
                return valText;
              } else {
                return null;
              }
            } else {
              return emailValidation(val);
            }
          },
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: isPass
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                  )
                : null,
            // filled: true,
            // fillColor: Colors.white,
            labelText: lablelText,
            hintText: hintText,
          ),
        ),
      ),
    );
  }

  void _handleSignUp(BuildContext context) async {
    final _form = _textFormKey.currentState;
    if (_form == null) {
      return null;
    }
    if (_form.validate()) {
      setState(() {
        _isLoading = true;
      });
      // UserModel userModel = UserModel();

      UserCredential? _user = await AuthenticationService()
          .signUp(
        email: _emailController.text,
        isAdmin: false,
        password: _passwordController.text,
        name: _userNameController.text,
        createdAt: null,
        joinedAt: DateTime.now().toString(),
        imageUrl: '',
        phoneNo: '',
      )
          .onError((error, stackTrace) {
        setState(() {
          _isLoading = false;
        });
        errorToast(message: "$error");
        return null;
      });
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      if (_user != null) {
        successToast(message: 'Successfully Registered');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => Announcements())));
      }
    }
  }
}
