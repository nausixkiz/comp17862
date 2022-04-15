import 'package:flutter/material.dart';
import 'package:iexplore/screen/auth/auth_register.dart';
import 'package:iexplore/screen/auth/auth_login.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // final _red = '#fe5f75'.toColor();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
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
            titleSpacing: 50,
            title: const Text(
              "iExplore",
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontFamily: "Lobster",
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  text: "Login",
                ),
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  text: "Register",
                )
              ],
              indicatorColor: Colors.white,
              indicatorWeight: 6,
            ),
          ),
          body: const TabBarView(
            children: [
              AuthLogin(),
              AuthRegister(),
            ],
          ),
        ));
  }
}
