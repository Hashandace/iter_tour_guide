import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LabelTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final String errorText;
  final bool isObscure;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final onSubmit;
  final String validator;
  final onChange;
  final FlatButton suffixIcon;
  final OutlineInputBorder errorBorder;
  final Color borderColor;
  final FocusNode node;
  final bool field;

  LabelTextField(

      {
      this.validator,
      this.controller,
      this.hintText,
      this.errorText,
      this.isObscure = false,
      this.textCapitalization = TextCapitalization.none,
      this.keyboardType = TextInputType.text,
      this.labelText,
      this.onSubmit,
      this.onChange,
      this.suffixIcon,
      this.errorBorder,
      this.node,
      this.borderColor,
      this.field});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: TextFormField(
        
        focusNode: node,
        controller: controller,
        decoration: new InputDecoration(
          hintText: hintText,
          labelText: labelText,
          hintStyle: TextStyle(
            fontSize: 16,
          ),
          errorText: errorText,
          filled: true,
          border: InputBorder.none,
          
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
          fillColor: Color(0xfff8f8f8),
          suffixIcon: suffixIcon,
        ),
        textCapitalization: textCapitalization,
        keyboardType: keyboardType,
        obscureText: isObscure,
        validator: RequiredValidator(errorText: "This field is required"),
        onChanged: onChange,
        showCursor: true,
        onSaved: onSubmit,
        onFieldSubmitted: onSubmit,
      ),
    );
  }
}
