import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iexplore/auth/auth_screen.dart';
import 'package:iexplore/homeScreen/home_screen.dart';
import 'package:iexplore/main.dart';

class MasterSplashScreen extends StatefulWidget {
  const MasterSplashScreen({Key? key}) : super(key: key);

  @override
  State<MasterSplashScreen> createState() => _MasterSplashScreenState();
}

class _MasterSplashScreenState extends State<MasterSplashScreen> {
  startTimer() {
    //Bug
    Timer(const Duration(seconds: 1), () async {
      if (firebaseAuth.currentUser == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("images/splash.jpg"),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "iExplore",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 40,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
