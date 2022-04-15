import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iexplore/main.dart';
import 'package:iexplore/models/firebaseModel/event_firebase_model.dart';
import 'package:iexplore/widgets/list_all_event_widget.dart';
import 'package:iexplore/widgets/progress_bar.dart';

class SearchEventScreen extends StatefulWidget {
  const SearchEventScreen({Key? key}) : super(key: key);

  @override
  State<SearchEventScreen> createState() => _SearchEventScreenState();
}

class _SearchEventScreenState extends State<SearchEventScreen> {
  Future<QuerySnapshot>? eventQuerySnapshot;
  String activityNameSearchText = "";

  Future<QuerySnapshot> searchEventByName(String searchText) async {
    var instance = FirebaseFirestore.instance
        .collection("i-explore/")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("events")
        .where("activityName", isGreaterThanOrEqualTo: searchText);
    eventQuerySnapshot = instance.get();

    return await instance.get();
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
        title: TextField(
          onChanged: (textEntered) {
            setState(() {
              activityNameSearchText = textEntered;
            });
            //init search
            searchEventByName(textEntered);
          },
          decoration: InputDecoration(
            hintText: "Search event's name here...",
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                searchEventByName(activityNameSearchText);
              },
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: eventQuerySnapshot,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something wrong in application"),
            );
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return circularProgress();
            case ConnectionState.done:
              // print(snapshot.hasData);
              // print(snapshot.data!.docs.length);
              // snapshot.data!.docs.forEach((doc) {
              //   print(doc["activityName"]);
              // });
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListAllEventWidget(
                        eventModel: EventFirebaseModel.fromJson(
                            snapshot.data!.docs[index].data()!
                                as Map<String, dynamic>),
                        context: context);
                  },
                );
              }

              return const Center(
                child: Text("No Record Found"),
              );
            default:
              return const Center(
                child: Text("Something Error"),
              );
          }
        },
      ),
    );
  }
}
