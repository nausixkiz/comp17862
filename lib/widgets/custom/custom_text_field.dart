import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? iconData;
  final String? text;
  final bool isObscure;
  final bool isEnabled;

  CustomTextField({
    this.controller,
    this.iconData,
    this.text,
    required this.isObscure,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: isEnabled,
        controller: controller,
        obscureText: isObscure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            border: const OutlineInputBorder(),
            labelStyle: const TextStyle(color: Colors.amber),
            prefixIcon: Icon(
              iconData,
              color: Colors.red,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: text),
      ),
    );
  }
}
