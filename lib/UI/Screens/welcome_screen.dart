import 'package:flutter/material.dart';
import 'dart:async';

import 'landing_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  
  SplashSerivces splashScreen = SplashSerivces();

  @override
  void initState() {
    super.initState();
    splashScreen.navigator(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.indigo,
        child: const Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to CN OEL!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Developed by:',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Muhammad Areeb',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
                ),
              ),
              Text(
                'Abdul Hannan',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SplashSerivces {
  void navigator(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LandingScreen())));
  }
}
