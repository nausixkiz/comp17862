import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iexplore/homeScreen/home_screen.dart';
import 'package:iexplore/main.dart';
import 'package:iexplore/models/event.dart';
import 'package:iexplore/objectbox.g.dart';
import 'package:iexplore/widgets/custom/custom_date_picker_text_field.dart';
import 'package:iexplore/widgets/custom/custom_time_picker_text_field.dart';
import 'package:iexplore/widgets/custom/custom_text_field.dart';
import 'package:iexplore/widgets/custom/custom_auto_fill_text_field.dart';
import 'package:iexplore/widgets/error_dialog.dart';
import 'package:uuid/uuid.dart';

class UploadReportAboutEventScreen extends StatefulWidget {
  const UploadReportAboutEventScreen({Key? key}) : super(key: key);

  @override
  State<UploadReportAboutEventScreen> createState() => _UploadReportAboutEventScreen();
}

class _UploadReportAboutEventScreen extends State<UploadReportAboutEventScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController activityNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateHeldController = TextEditingController();
  TextEditingController timeOfAttendingController = TextEditingController();
  TextEditingController nameOfReporterController = TextEditingController();
  var _uuid = Uuid().v1().toString();

  Future<void> saveData() async{
    final _activityName = activityNameController.text.trim();
    final _location = locationController.text.isNotEmpty ? locationController.text.trim() : " ";
    final _dateHeld = dateHeldController.text.trim();
    final _timeOfAttending = timeOfAttendingController.text.isNotEmpty ? timeOfAttendingController.text.trim() : " ";
    final _nameOfReporter= nameOfReporterController.text.trim();

    final ref = FirebaseFirestore.instance.collection("i-explore").doc(currentAccount!.firebaseUuid).collection("events").doc(_uuid).set({
      "firebaseUuid": _uuid,
      "activityName": _activityName,
      "location": _location,
      "dateHeld": _dateHeld,
      "timeOfAttending": _timeOfAttending,
      "nameOfReporter": _nameOfReporter,
    });

    try {
      await eventObjectBox.putAsync(Event(
          firebaseUuid: _uuid,
          activityName: _activityName,
          location: _location,
          dateHeld:  _dateHeld,
          timeOfAttending: _timeOfAttending,
          nameOfReporter: _nameOfReporter,
      ));
    } on UniqueViolationException catch (e) {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return ErrorDialog(
            message: e.message.toString(),
          );
        },
      );
    }
    clearAllInput();
  }

  Future<void> formValidation() async{
    if(activityNameController.text.isNotEmpty && dateHeldController.text.isNotEmpty && nameOfReporterController.text.isNotEmpty){
      await saveData();
    }
    else{
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return ErrorDialog(
            message: "Please fill in all the required fields",
          );
        },
      );
    }
  }

  clearAllInput(){
    setState(() {
      activityNameController.clear();
      locationController.clear();
      dateHeldController.clear();
      timeOfAttendingController.clear();
      nameOfReporterController.clear();
      _uuid = Uuid().v1().toString();
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
          title: const Text("Create A New Report",
              style: TextStyle(fontSize: 20, fontFamily: "Lobster")),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () {
              clearAllInput();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          actions: [
            TextButton( child: const Text("Add", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 3),), onPressed: () { formValidation(); }),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 30,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                        iconData: Icons.celebration,
                        controller: activityNameController,
                        text: "Activity Name",
                        isObscure: false,
                        isEnabled: true),
                    CustomTextField(
                        iconData: Icons.add_location,
                        controller: locationController,
                        text: "Location",
                        isObscure: false,
                        isEnabled: true),
                    CustomDatePickerTextField(
                        iconData: Icons.calendar_today,
                        controller: dateHeldController,
                        text: "Date Held"),
                    CustomTimePickerTextField(
                        iconData: Icons.access_time,
                        controller: timeOfAttendingController,
                        text: "Time Of Attending"),
                    CustomAutoFillTextField(
                        iconData: Icons.account_circle,
                        controller: nameOfReporterController,
                        text: "Name Of Reporter",
                        textFill: currentAccount!.name,
                    ),
                  ],
                )),
          ],
        )));
  }
}
