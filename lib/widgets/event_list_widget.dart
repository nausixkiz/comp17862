import 'package:flutter/material.dart';
import 'package:iexplore/models/firebaseModel/event_firebase_model.dart'
    as firebase_event_model;

class EventListWidget extends StatefulWidget {
  firebase_event_model.EventFirebaseModel? model;
  BuildContext? context;

  EventListWidget({this.model, this.context});

  @override
  State<EventListWidget> createState() => _EventListWidget();
}

class _EventListWidget extends State<EventListWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Text(
                widget.model!.activityName!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "Train",
                ),
              ),
              Text(
                widget.model!.nameOfReporter!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
