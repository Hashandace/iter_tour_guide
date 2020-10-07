import 'package:flutter/material.dart';

class Titles extends StatelessWidget {
  final String title;
  final Color color;
  final double fontSize;

  const Titles({Key key, this.title, this.color, this.fontSize}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: fontSize
      ),
    );
  }

  
}
