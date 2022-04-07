import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iexplore/main.dart';
import 'package:iexplore/objectbox.g.dart';

import '../widgets/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var appBarTitleText = const Text("Welcome new user");

  Future<void> readCurrentUserInLocal() async {
    await FirebaseFirestore.instance
        .collection("i-explore")
        .doc(firebaseAuth.currentUser?.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        final query = accountObjectBox
            .query(Account_.email.equals(snapshot.data()!["email"]))
            .build();
        currentAccount = query.findFirst();

        query.close();
        setState(() {
          appBarTitleText = Text("Welcome " + currentAccount!.name);
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    readCurrentUserInLocal();
    super.initState();
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
        title: appBarTitleText,
        centerTitle: true,
        // automaticallyImplyLeading: false,
      ),
      drawer: const HomeDrawer(),
    );
  }
}
