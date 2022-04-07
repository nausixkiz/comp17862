import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as f_storage;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iexplore/homeScreen/home_screen.dart';
import 'package:iexplore/main.dart';
import 'package:iexplore/models/objectBoxModel/account.dart';
import 'package:iexplore/objectbox.g.dart';
import 'package:iexplore/widgets/custom/custom_text_field.dart';
import 'package:iexplore/widgets/error_dialog.dart';
import 'package:iexplore/widgets/loading.dart';
import 'package:image_picker/image_picker.dart';

class AuthRegister extends StatefulWidget {
  const AuthRegister({Key? key}) : super(key: key);

  @override
  State<AuthRegister> createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;
  String avatarUrl = "";
  String completeAddress = "";

  Future<void> _getImage() async {
    imageXFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];

    completeAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    addressController.text = completeAddress;
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return ErrorDialog(
            message: "Please pick an image",
          );
        },
      );
    } else {
      if (passwordController.text == passwordConfirmController.text) {
        if (nameController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty &&
            passwordConfirmController.text.isNotEmpty &&
            phoneController.text.isNotEmpty &&
            addressController.text.isNotEmpty) {
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            // false = user must tap button, true = tap outside dialog
            builder: (BuildContext dialogContext) {
              return const LoadingDialog();
            },
          );
          String imageFileName =
              DateTime.now().millisecondsSinceEpoch.toString();
          f_storage.Reference reference = f_storage.FirebaseStorage.instance
              .ref()
              .child("i-explore")
              .child(imageFileName);
          f_storage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
          f_storage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() => {});
          await taskSnapshot.ref.getDownloadURL().then((value) {
            avatarUrl = value;
            authUserAndRegister();
          });
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
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          // false = user must tap button, true = tap outside dialog
          builder: (BuildContext dialogContext) {
            return ErrorDialog(
              message: "Password confirmation doesn't match Password",
            );
          },
        );
      }
    }
  }

  Future<void> authUserAndRegister() async {
    User? user;

    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((value) => {user = value.user})
        .catchError((error) {
      Navigator.pop(context);
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return ErrorDialog(
            message: error.message.toString(),
          );
        },
      );
    });
    if (user != null) {
      saveDataUserToObjectBox(
        user!.uid,
        nameController.text,
        emailController.text,
        passwordController.text,
        phoneController.text,
        addressController.text,
      );
      saveDataToFirebase(user!).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => const HomeScreen());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  /// Save User Data
  Future<void> saveDataUserToObjectBox(String _uid, String _name, String _email,
      String _password, String _phone, String _address) async {
    final query = accountObjectBox.query(Account_.email.equals(_email)).build();
    final userResults = query.find();
    query.close();

    if (userResults.isEmpty) {
      try {
        await accountObjectBox.putAsync(Account(
            firebaseUuid: _uid,
            name: _name.trim(),
            email: _email.trim(),
            password: Crypt.sha512(_password.trim()).toString(),
            phone: _phone.trim(),
            address: _address.trim(),
            avatarUrl: avatarUrl));
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
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return ErrorDialog(
            message: "This user is already exists",
          );
        },
      );
    }
  }

  Future<void> saveDataToFirebase(User user) async {
    FirebaseFirestore.instance.collection("i-explore").doc(user.uid).set({
      "uid": user.uid,
      "name": nameController.text.trim(),
      "email": user.email,
      "password": Crypt.sha512(passwordController.text.trim()).toString(),
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "avatarUrl": avatarUrl,
    });
  }

  /// End Save User Data

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _getImage();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage:
                  imageXFile == null ? null : FileImage(File(imageXFile!.path)),
              child: imageXFile == null
                  ? Icon(
                      Icons.add_a_photo,
                      size: MediaQuery.of(context).size.width * 0.20,
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                    iconData: Icons.person,
                    controller: nameController,
                    text: "Name",
                    isObscure: false,
                    isEnabled: true),
                CustomTextField(
                    iconData: Icons.email,
                    controller: emailController,
                    text: "Email",
                    isObscure: false,
                    isEnabled: true),
                CustomTextField(
                    iconData: Icons.lock,
                    controller: passwordController,
                    text: "Password",
                    isObscure: true,
                    isEnabled: true),
                CustomTextField(
                    iconData: Icons.lock,
                    controller: passwordConfirmController,
                    text: "Confirm Your Password",
                    isObscure: true,
                    isEnabled: true),
                CustomTextField(
                    iconData: Icons.phone_android,
                    controller: phoneController,
                    text: "Telephone Number",
                    isObscure: false,
                    isEnabled: true),
                CustomTextField(
                    iconData: Icons.location_city,
                    controller: addressController,
                    text: "Address",
                    isObscure: false,
                    isEnabled: false),
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () => {
                      getCurrentLocation(),
                    },
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    label: const Text("Get My Location",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                formValidation();
              },
              child: const Text("Register",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80, vertical: 10))),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
