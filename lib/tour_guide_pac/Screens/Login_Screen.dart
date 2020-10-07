//This is the Login Screen UI
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iter_tour_guide/tour_guide_pac/Screens/main_screen.dart';
import 'package:iter_tour_guide/tour_guide_pac/Screens/reset_password.dart';
import 'package:iter_tour_guide/tour_guide_pac/Screens/signup_screen.dart';
import 'package:iter_tour_guide/tour_guide_pac/Services/auth_Service.dart';
import 'package:iter_tour_guide/tour_guide_pac/Widgets/focus_helper.dart';
import 'package:iter_tour_guide/tour_guide_pac/Widgets/lable_text_field.dart';
import 'package:iter_tour_guide/tour_guide_pac/Widgets/titles.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  AuthMethods authMethods = AuthMethods();

  final focus = FocusNode();
  ScrollController _scroll;
  FocusNode _focusNodePwd = new FocusNode();
  FocusNode _focusNodeEmail = new FocusNode();

  final storage = new FlutterSecureStorage();

  bool isObsecure = true;
  bool email = false;
  bool pwd = false;

  Color buttonColor;

  @override
  void initState() {
    super.initState();
  }

  void _toggle() {
    setState(() {
      isObsecure = !isObsecure;
    });
  }

  void showCenterShortLoadingToast() {
    FlutterFlexibleToast.showToast(
        message: "Short Loading 2 Sec Toast",
        toastLength: Toast.LENGTH_LONG,
        toastGravity: ToastGravity.BOTTOM,
        icon: ICON.LOADING,
        radius: 20,
        elevation: 10,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        timeInSeconds: 2);
  }

  void showColoredToast(color, message) {
    FlutterFlexibleToast.showToast(
        message: message,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: color,
        icon: ICON.SUCCESS,
        fontSize: 16,
        imageSize: 35,
        textColor: Colors.white);
  }

  Future signIn()  {
    showCenterShortLoadingToast();
    return authMethods.signIn(_email.text, _password.text).then((value) async {
      if (value != null)  {
        showColoredToast(Colors.green, "Login Success");
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen(uid: user.uid)));
      } else {
        showColoredToast(Colors.red, "Login failed");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.only(left: 32, right: 32, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          _title(),
          Spacer(),
          _titleHeadings("Email"),
          SizedBox(height: 8),
          _emailField(),
          SizedBox(height: 4),
          _validateEmail(),
          SizedBox(height: 32),
          _titleHeadings("Password"),
          SizedBox(height: 8),
          _passwordField(),
          SizedBox(height: 4),
          _validatePassword(),
          _forgotPassword(),
          Spacer(),
          _signInButton(),
          _registerLable(),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _title() {
    return Align(
      alignment: Alignment.topCenter,
      child: Titles(
        color: Colors.blueAccent,
        fontSize: 20,
        title: "Sign In",
      ),
    );
  }

  Widget _titleHeadings(String _field) {
    return Align(
      alignment: Alignment.topLeft,
      child: Titles(
        color: Colors.blueAccent,
        fontSize: 14,
        title: _field,
      ),
    );
  }

  Widget _emailField() {
    return EnsureVisibleWhenFocused(
      focusNode: _focusNodeEmail,
      child: LabelTextField(
        node: _focusNodeEmail,
        onChange: (v) {
          if (_email.text.isEmpty) {
            setState(() {
              email = true;
            });
          } else {
            setState(() {
              email = false;
            });
          }
          if (_email.text.isNotEmpty) {
            setState(() {});
          }
        },
        onSubmit: (v) {
          if (_email.text.isEmpty) {
            setState(() {
              email = true;
            });
          } else {
            setState(() {
              email = false;
            });
          }
          if (_email.text.isNotEmpty) {
            setState(() {});
          }
          FocusScope.of(context).requestFocus(_focusNodePwd);
        },
        borderColor: email ? Colors.red : Color(0xffeaeaea),
        hintText: "JhoneDoe@gmail.com",
        controller: _email,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _passwordField() {
    return EnsureVisibleWhenFocused(
      focusNode: _focusNodePwd,
      child: LabelTextField(
        node: _focusNodePwd,
        onChange: (v) {
          if (_password.text.isNotEmpty) {
            setState(() {});
          }

          if (_password.text.isEmpty) {
            setState(() {
              pwd = true;
            });
          } else {
            setState(() {
              pwd = false;
            });
          }
        },
        onSubmit: (v) {
          if (_password.text.isNotEmpty) {
            setState(() {});
          }

          if (_password.text.isEmpty) {
            setState(() {
              pwd = true;
            });
          } else {
            setState(() {
              pwd = false;
            });
          }
          FocusScope.of(context).unfocus();
        },
        borderColor: pwd ? Colors.red : Color(0xffeaeaea),
        isObscure: isObsecure,
        suffixIcon: FlatButton(
            onPressed: () {
              setState(() {
                _toggle();
              });
            },
            child: isObsecure
                ? Text(
                    "Show",
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  )
                : Text("Hide",
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ))),
        hintText: "XXXXXXX",
        controller: _password,
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _validateEmail() {
    return email
        ? Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Email is required",
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          )
        : SizedBox();
  }

  Widget _validatePassword() {
    return pwd
        ? Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Password is required",
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          )
        : SizedBox();
  }

  Widget _signInButton() {
    return Container(
      width: MediaQuery.of(context).size.width - 64,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.blueAccent,
        child: Text(
          "Sign In",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          signIn();
        },
      ),
    );
  }

  Widget _registerLable() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Don't have account ?"),
        FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: Text("Sign Up", style: TextStyle(color: Colors.blueAccent)))
      ],
    );
  }

  Widget _forgotPassword() {
    return Align(
      alignment: Alignment.topRight,
      child: FlatButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResetPassword()));
          },
          child: Text(
            "Forgot password",
            style: TextStyle(color: Colors.blueAccent),
          )),
    );
  }
}
