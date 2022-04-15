import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iexplore/main.dart';
import 'package:iexplore/screen/auth/auth_screen.dart';
import 'package:iexplore/screen/home/home_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.red,
              Colors.deepOrange,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: const Text("iExplore",
            style: TextStyle(fontSize: 20, fontFamily: "Lobster")),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Material(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Welcome to iExplore",
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
      ),
    );
  }
}
