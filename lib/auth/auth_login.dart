import 'package:flutter/material.dart';
import 'package:iexplore/homeScreen/home_screen.dart';
import 'package:iexplore/main.dart';
import 'package:iexplore/widgets/error_dialog.dart';
import 'package:iexplore/widgets/loading.dart';

import '../widgets/custom_text_field.dart';

class AuthLogin extends StatefulWidget {
  const AuthLogin({Key? key}) : super(key: key);

  @override
  State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> formValidation() async{
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
      authLogin();
    }
    else{
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

  Future<void> authLogin() async{
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return const LoadingDialog();
      },
    );

    await firebaseAuth.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim())
        .then((value) {
          Navigator.pop(context);
              Navigator.push(
              context, MaterialPageRoute(builder: (c) => const HomeScreen()));
          })
        .catchError((error) {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Form(key: _formKey, child: Column(
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
              onPressed:  () {
                formValidation();
              },
              child: const Text("Login",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80, vertical: 10))),
        ],
      ),
    );
  }
}
