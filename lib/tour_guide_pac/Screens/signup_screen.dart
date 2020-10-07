import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:iter_tour_guide/tour_guide_pac/Services/auth_Service.dart';
import 'package:iter_tour_guide/tour_guide_pac/Widgets/lable_text_field.dart';
import 'package:iter_tour_guide/tour_guide_pac/Widgets/titles.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _nic = TextEditingController();
  TextEditingController _telepone = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _cnfpassword = TextEditingController();

  String dropdownValue = 'English';
  Color bordercolor = Colors.blue;

  AuthMethods authMethods = new AuthMethods();
  final storage = new FlutterSecureStorage();

  signUp() {
    authMethods.signUp(_email.text, _password.text).then((value) async {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid;

      Map<String, dynamic> userinfo = {
        'uid': uid,
        'email': _email.text,
        'name': _name.text,
        'age': _age.text,
        'language': dropdownValue,
        'nic': _nic.text,
        'telephone': _telepone.text,
        'picture': "",
        'availability_status': 'active',
      };

      authMethods.uploadUserInfo(userinfo);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.only(left: 32, right: 32),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          _title(),
          SizedBox(height: 20),
          _titleHeadings("Email"),
          _emailField(),
          SizedBox(height: 20),
          _titleHeadings("Name"),
          _nameField(),
          SizedBox(height: 20),
          _titleHeadings("Password"),
          _passwordfield(),
          SizedBox(height: 20),
          _titleHeadings("Confirm Password"),
          _passwordfield(),
          SizedBox(height: 20),
          _titleHeadings("Age"),
          _ageField(),
          SizedBox(height: 20),
          _titleHeadings("Support language"),
          _languageDropdown(),
          SizedBox(height: 20),
          _titleHeadings("NIC"),
          _nicField(),
          SizedBox(height: 20),
          _titleHeadings("Telephone"),
          _telephoneField(),
          SizedBox(height: 32),
          _registerButton(),
          SizedBox(height: 16),
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
        title: "Sign Up",
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
    return LabelTextField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      borderColor: bordercolor,
      hintText: "Jhondoe@gmail.com",
    );
  }

  Widget _nameField() {
    return LabelTextField(
      controller: _name,
      borderColor: Colors.blueAccent,
      hintText: "Jhon Doe",
    );
  }

  Widget _ageField() {
    return LabelTextField(
      controller: _age,
      borderColor: Colors.blueAccent,
      hintText: "18",
    );
  }

  Widget _nicField() {
    return LabelTextField(
      controller: _nic,
      borderColor: Colors.blueAccent,
      hintText: "xxxxxxxxxV",
    );
  }

  Widget _telephoneField() {
    return LabelTextField(
      controller: _telepone,
      borderColor: Colors.blueAccent,
      hintText: "07X XXX XXXX",
    );
  }

  Widget _passwordfield() {
    return LabelTextField(
      isObscure: true,
      controller: _password,
      borderColor: Colors.blueAccent,
      hintText: "xxxxxx",
    );
  }

  Widget _confirmPassowrd() {
    return LabelTextField(
      controller: _cnfpassword,
      borderColor: Colors.blueAccent,
      hintText: "xxxxxx",
    );
  }

  Widget _registerButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.blueAccent,
      onPressed: () async {
        _email.text.isEmpty ||
                _name.text.isEmpty ||
                _password.text.isEmpty ||
                _age.text.isEmpty ||
                _nic.text.isEmpty ||
                _telepone.text.isEmpty
            ? FlutterFlexibleToast.showToast(
                message: "Please fill all the fields")
            : signUp();
      },
      child: Text(
        "Sign Up",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _languageDropdown() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['English', 'Sinhala', 'Tamil']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
