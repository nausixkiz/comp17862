import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iexplore/main.dart';
import 'package:iexplore/screen/home/home_screen.dart';
import 'package:iexplore/widgets/custom/custom_auto_fill_text_field.dart';
import 'package:iexplore/widgets/custom/custom_date_picker_text_field.dart';
import 'package:iexplore/widgets/custom/custom_text_field.dart';
import 'package:iexplore/widgets/custom/custom_time_picker_text_field.dart';
import 'package:iexplore/widgets/error_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EventCreateScreen extends StatefulWidget {
  const EventCreateScreen({Key? key}) : super(key: key);

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController activityNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateHeldController = TextEditingController();
  TextEditingController timeOfAttendingController = TextEditingController();
  TextEditingController nameOfReporterController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  var _uuid = const Uuid().v1().toString();

  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> saveData() async {
    final _activityName = activityNameController.text.trim();
    final _location = locationController.text.isNotEmpty
        ? locationController.text.trim()
        : " ";
    final _dateHeld = dateHeldController.text.trim();
    final _timeOfAttending = timeOfAttendingController.text.isNotEmpty
        ? timeOfAttendingController.text.trim()
        : " ";
    final _nameOfReporter = nameOfReporterController.text.trim();
    final _report = reportController.text.trim();
    String thumpUrl = "";

    if (imageXFile != null) {
      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("i-explore")
          .child(imageFileName);
      UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
      await taskSnapshot.ref.getDownloadURL().then((value) {
        thumpUrl = value;
      });
    }

    await FirebaseFirestore.instance
        .collection("i-explore")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("events")
        .doc(_uuid)
        .set({
      "firebaseUuid": _uuid,
      "activityName": _activityName,
      "location": _location,
      "dateHeld": _dateHeld,
      "timeOfAttending": _timeOfAttending,
      "nameOfReporter": _nameOfReporter,
      "thumpUrl": thumpUrl,
      "report": _report,
    }).then((value) {
      Fluttertoast.showToast(
          msg: "Event Created Successfully.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      clearAllInput();
    });
  }

  Future<void> formValidation() async {
    if (activityNameController.text.isNotEmpty &&
        dateHeldController.text.isNotEmpty &&
        nameOfReporterController.text.isNotEmpty) {
      await saveData();
    } else {
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

  clearAllInput() {
    setState(() {
      activityNameController.clear();
      locationController.clear();
      dateHeldController.clear();
      timeOfAttendingController.clear();
      nameOfReporterController.clear();
      reportController.clear();
      _uuid = const Uuid().v1().toString();
      imageXFile = null;
    });
  }

  Future<void> captureImageWithCamera() async {
    Navigator.pop(context);

    imageXFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  Future<void> pickImageFromGallery() async {
    Navigator.pop(context);

    imageXFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
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
          title: const Text("Create New Event",
              style: TextStyle(fontSize: 20, fontFamily: "Lobster")),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              clearAllInput();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          actions: [
            TextButton(
                child: const Text(
                  "Add",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                ),
                onPressed: () {
                  formValidation();
                }),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              child: const Text(
                "Add New Thumbnail",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text(
                        "Event Thumbnail",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        SimpleDialogOption(
                          child: const Text(
                            "Capture with Camera",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: captureImageWithCamera,
                        ),
                        SimpleDialogOption(
                          child: const Text(
                            "Select from Gallery",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: pickImageFromGallery,
                        ),
                        SimpleDialogOption(
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
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
                      textFill: firebaseAuth.currentUser!.displayName,
                    ),
                    CustomTextField(
                        iconData: Icons.edit_note,
                        controller: reportController,
                        text: "Report",
                        isObscure: false,
                        isEnabled: true),
                  ],
                )),
          ],
        )));
  }
}
