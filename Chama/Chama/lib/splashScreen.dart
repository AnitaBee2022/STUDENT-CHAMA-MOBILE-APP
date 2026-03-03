import 'package:chama/homepage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Homepage()));
    });
  }
    @override
  Widget build(BuildContext context) {
    return  Scaffold(
    backgroundColor: Colors.white,
  body: Center(
  child: ClipOval(
  child: Image.asset(
  'assets/images/logo.png', // Replace with your image path
  width: 150,  // Adjust size as needed
  height: 150,
  fit: BoxFit.cover,
  ),
  ),
  ),
  );
  }
}


