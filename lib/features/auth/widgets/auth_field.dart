import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallette.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const AuthField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallette.blueColor,
            width: 3.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallette.greyColor,
          ),
        ),
        contentPadding: const EdgeInsets.all(22.0),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 18.0),
      ),
    );
  }
}
