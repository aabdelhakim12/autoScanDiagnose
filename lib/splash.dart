import 'package:autoscan_diagnose/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      useLoader: false,
      gradientBackground: LinearGradient(colors: [
        Colors.cyan[900],
        Colors.blueGrey,
      ]),
      seconds: 2,
      navigateAfterSeconds: Home(),
      title: Text(
        'Auto Scan Diagnose',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      photoSize: 150,
      image: Image.asset(
        'assets/images/auto.png',
      ),
    );
  }
}
