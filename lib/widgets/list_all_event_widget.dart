import 'package:flutter/material.dart';
import 'package:iexplore/models/firebaseModel/event_firebase_model.dart';
import 'package:iexplore/screen/event/event_detail_screen.dart';

class ListAllEventWidget extends StatefulWidget {
  EventFirebaseModel eventModel;
  BuildContext context;

  ListAllEventWidget({required this.eventModel, required this.context});

  @override
  State<ListAllEventWidget> createState() => _ListAllEventWidgetState();
}

class _ListAllEventWidgetState extends State<ListAllEventWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => EventDetailScreen(
                      eventModel: widget.eventModel,
                      context: widget.context,
                    )));
      },
      splashColor: Colors.red,
      child: Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.eventModel.activityName!,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text.rich(
                      TextSpan(
                        style:
                            const TextStyle(fontSize: 17, color: Colors.grey),
                        children: [
                          const WidgetSpan(
                            child: Icon(
                              Icons.add_location,
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: widget.eventModel.location!,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.eventModel.dateHeld!,
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                widget.eventModel.thumpUrl!.isNotEmpty
                    ? Image.network(
                        widget.eventModel.thumpUrl!,
                        height: double.infinity,
                        width: 100,
                      )
                    : Image.asset("images/event-default.png"),
              ],
            ),
          )),
    );
  }
}
