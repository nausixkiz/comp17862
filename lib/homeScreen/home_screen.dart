import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iexplore/main.dart';
import 'package:iexplore/models/firebaseModel/event_firebase_model.dart' as firebase_event_model;
import 'package:iexplore/objectbox.g.dart';
import 'package:iexplore/screen/upload/upload_report_about_event_screen.dart';
import 'package:iexplore/widgets/event_list_widget.dart';
import 'package:iexplore/widgets/home_drawer.dart';
import 'package:iexplore/widgets/progress_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var appBarTitleText = const Text(
    "Welcome new user",
    style: TextStyle(fontSize: 20, fontFamily: "Lobster"),
  );

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
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.post_add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => const UploadReportAboutEventScreen()));
              })
        ],
      ),
      drawer: const HomeDrawer(),
      body: CustomScrollView(
        slivers: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("i-explore").doc(currentAccount!.firebaseUuid).collection("event").snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData ?
              SliverToBoxAdapter(child: circularProgress(),) :
              SliverStaggeredGrid.countBuilder(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                staggeredTileBuilder: (context) =>  const StaggeredTile.fit(1),
                // itemCount: imageList.length,
                itemBuilder: (context, index) {
                  firebase_event_model.EventFirebaseModel eventModel = firebase_event_model.EventFirebaseModel.fromJson(snapshot.data!.docs[index].data()! as Map<String, dynamic>);
                  return EventListWidget(model: eventModel, context: context,);
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          )
        ],
      ),
    );
  }
}
