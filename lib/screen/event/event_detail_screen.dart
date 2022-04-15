import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iexplore/main.dart';
import 'package:iexplore/models/firebaseModel/event_firebase_model.dart';
import 'package:iexplore/screen/event/event_update_screen.dart';
import 'package:iexplore/screen/home/home_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final EventFirebaseModel? eventModel;
  final BuildContext? context;

  EventDetailScreen({this.eventModel, this.context});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Future<void> deleteEvent(String? uuid) async {
    FirebaseFirestore.instance
        .collection("i-explore")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("events")
        .doc(uuid)
        .delete()
        .then((value) {
      Fluttertoast.showToast(
          msg: "Event Deleted Successfully.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => const HomeScreen()));
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
          title: Text(
            widget.eventModel!.activityName! + " Detail",
            style: const TextStyle(fontSize: 20, fontFamily: "Lobster"),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.eventModel!.thumpUrl!.isNotEmpty
                    ? Image.network(
                        widget.eventModel!.thumpUrl!,
                        height: 220.0,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "images/event-default.png",
                        height: 220.0,
                        fit: BoxFit.cover,
                      ),
                const SizedBox(
                  width: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.eventModel!.activityName.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Location: " + widget.eventModel!.location.toString(),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Date Held: " + widget.eventModel!.dateHeld.toString(),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Time Of Attending: " +
                        widget.eventModel!.timeOfAttending.toString(),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Name Of Reporter: " +
                        widget.eventModel!.nameOfReporter.toString(),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Reports: " + widget.eventModel!.report.toString(),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Expanded(
                        child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => EventUpdateScreen(
                                          eventModel: widget.eventModel,
                                          context: widget.context,
                                        )));
                          },
                          child: const Text("Update Event",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10))),
                    )),
                    const SizedBox(
                      height: 50,
                    ),
                    Expanded(
                        child: Center(
                      child: ElevatedButton(
                          onPressed: () {
                            deleteEvent(widget.eventModel!.firebaseUuid);
                          },
                          child: const Text("Delete Event",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10))),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ]),
        ));
  }
}
