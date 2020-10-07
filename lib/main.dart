import 'package:custom_splash/custom_splash.dart';
import "package:flutter/material.dart";
import 'package:iter_tour_guide/tour_guide_pac/Screens/Login_Screen.dart';


void main() {
 Function duringSplash = () {
    print('Something background process');
    int a = 123 + 23;
    print(a);

    if (a > 100)
      return 1;
    else
      return 2;
  };

  Map<int, Widget> op = {1: MyApp(), 2: MyApp()};

  runApp(MaterialApp(
    home: CustomSplash(
    
      imagePath: 'assets/images/35045612.png',
      backGroundColor: Colors.deepOrange,
      animationEffect: 'zoom-in',
      logoSize: 200,
      home: MyApp(),
      customFunction: duringSplash,
      duration: 2500,
      type: CustomSplashType.StaticDuration,
      outputAndHome: op,
    ),
  ));
  
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue), home: LoginPage());
  }
}