import 'package:flutter/material.dart';

class CustomAutoFillTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? iconData;
  final String text;
  final String? textFill;
  final bool isObscure = false;
  final bool isEnabled = true;

  CustomAutoFillTextField({
    required this.controller,
    this.iconData,
    required this.text,
    this.textFill,
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
        onTap: () {
          if (controller.text.isEmpty) {
            controller.text = textFill!;
          }
        },
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
