import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iexplore/main.dart';
import 'package:iexplore/models/firebaseModel/event_firebase_model.dart';
import 'package:iexplore/screen/auth/auth_screen.dart';
import 'package:iexplore/screen/event/event_create_screen.dart';
import 'package:iexplore/screen/event/search_event_screen.dart';
import 'package:iexplore/widgets/list_all_event_widget.dart';
import 'package:iexplore/widgets/progress_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  String avatarUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      setState(() {
        name = firebaseAuth.currentUser!.displayName!;
        avatarUrl = firebaseAuth.currentUser!.photoURL!;
      });
    });
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
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 20, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.post_add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => const EventCreateScreen()));
              })
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            // Head
            Container(
              padding: const EdgeInsets.only(top: 25, bottom: 10),
              child: Column(
                children: [
                  Material(
                    borderRadius: const BorderRadius.all(Radius.circular(80)),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                        color: Colors.red, fontSize: 20, fontFamily: "Varela"),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Body
            Container(
              padding: const EdgeInsets.only(top: 1.0),
              child: Column(
                children: [
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Home",
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const HomeScreen()));
                    },
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.history,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "History",
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Search",
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const SearchEventScreen()));
                    },
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 2,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Log Out",
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      firebaseAuth.signOut().then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const AuthScreen()));
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("i-explore")
                .doc(firebaseAuth.currentUser!.uid)
                .collection("events")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                    'Error in receiving event from firebase: ${snapshot.error}');
              }

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Text('Not connected to the Stream or null');

                case ConnectionState.waiting:
                  return Center(child: circularProgress());

                case ConnectionState.active:
                  int eventItemCount = snapshot.data!.docs.length;

                  if (snapshot.hasData) {
                    if (eventItemCount < 1) {
                      return Center(
                          child: Column(
                        children: const <Widget>[
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          Text("No event found.")
                        ],
                      ));
                    }
                    return GridView.builder(
                        itemCount: eventItemCount,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                mainAxisExtent: 150),
                        itemBuilder: (BuildContext context, int index) {
                          return ListAllEventWidget(
                              eventModel: EventFirebaseModel.fromJson(
                                  snapshot.data!.docs[index].data()!
                                      as Map<String, dynamic>),
                              context: context);
                        });
                  }
                  return Center(
                      child: Column(
                    children: const <Widget>[
                      Padding(padding: EdgeInsets.only(top: 50.0)),
                      Text("No event found.")
                    ],
                  ));

                case ConnectionState.done:
                  return const Text('Streaming is done');
              }
            },
          ),
        ],
      ),
    );
  }
}
