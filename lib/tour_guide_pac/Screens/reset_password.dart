import 'package:flutter/material.dart';
import 'package:iter_tour_guide/tour_guide_pac/Services/auth_Service.dart';
import 'package:iter_tour_guide/tour_guide_pac/Widgets/lable_text_field.dart';
import 'package:iter_tour_guide/tour_guide_pac/Widgets/titles.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 32),
        _resetTitle(),
        Spacer(),
        _titleHeadings("Email"),
        _resetEmailField(),
        Spacer(),
        _resetButton(),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _resetTitle() {
    return Titles(
      title: "Reset password",
      color: Colors.blueAccent,
      fontSize: 20,
    );
  }

  Widget _titleHeadings(String _field) {
    return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 32),
          child: Titles(
            color: Colors.blueAccent,
            fontSize: 14,
            title: _field,
          ),
        ));
  }

  Widget _resetEmailField() {
    return Padding(
      padding: EdgeInsets.only(left: 32, right: 32),
      child: LabelTextField(
        controller: _email,
        borderColor: Color(0xffaeaeae),
        hintText: "JhonDie@gmail.com",
      ),
    );
  }

  Widget _resetButton() {
    return Padding(
        padding: EdgeInsets.only(left: 32, right: 32),
        child: Container(
          width: MediaQuery.of(context).size.width - 64,
          child: RaisedButton(
            color: Colors.teal,
            child: Text(
              "Reset password",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              AuthMethods authMethods = AuthMethods();

              authMethods.resetPassword(_email.text);
            },
          ),
        ));
  }

}
