import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:iexplore/main.dart';
import 'package:iexplore/models/objectBoxModel/account_object_box_model.dart';
import 'package:iexplore/objectbox.g.dart';
import 'package:iexplore/screen/auth/auth_screen.dart';
import 'package:iexplore/screen/home/home_screen.dart';
import 'package:iexplore/widgets/custom/custom_text_field.dart';
import 'package:iexplore/widgets/error_dialog.dart';
import 'package:iexplore/widgets/loading.dart';

class AuthLogin extends StatefulWidget {
  const AuthLogin({Key? key}) : super(key: key);

  @override
  State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> formValidation() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      authLogin();
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return ErrorDialog(message: "Please fill in all the required fields");
        },
      );
    }
  }

  Future<void> saveDataUserToObjectBox(
      String _uid,
      String _name,
      String _email,
      String _password,
      String _phone,
      String _address,
      String _avatarUrl) async {
    final query = accountObjectBox
        .query(AccountObjectBoxModel_.email.equals(_email))
        .build();
    final userResults = query.find();
    query.close();

    if (userResults.isEmpty) {
      try {
        await accountObjectBox.putAsync(AccountObjectBoxModel(
            firebaseUuid: _uid,
            name: _name.trim(),
            email: _email.trim(),
            password: Crypt.sha512(_password.trim()).toString(),
            phone: _phone.trim(),
            address: _address.trim(),
            avatarUrl: _avatarUrl));
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

  Future<void> authLogin() async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return const LoadingDialog();
      },
    );

    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((user) async {
      await FirebaseFirestore.instance
          .collection("i-explore")
          .doc(user.user!.uid)
          .get()
          .then((snapshot) async {
        if (snapshot.exists) {
          await saveDataUserToObjectBox(
            user.user!.uid,
            snapshot.data()!["name"],
            snapshot.data()!["email"],
            snapshot.data()!["password"],
            snapshot.data()!["phone"],
            snapshot.data()!["address"],
            snapshot.data()!["avatarUrl"],
          );
          readAndSetCurrentAccount(snapshot.data()!["email"]);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const HomeScreen()));
        } else {
          firebaseAuth.signOut();
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const AuthScreen()));
        }
      });
    }).catchError((error) {
      Navigator.pop(context);
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return ErrorDialog(message: error.message.toString());
        },
      );
    });
  }

  Future<void> readAndSetCurrentAccount(String _email) async {
    final query = accountObjectBox
        .query(AccountObjectBoxModel_.email.equals(_email))
        .build();
    currentAccount = query.findFirst();
    query.close();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
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
                ],
              )),
          ElevatedButton(
              onPressed: () {
                formValidation();
              },
              child: const Text("Login",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80, vertical: 10))),
        ],
      ),
    );
  }
}
