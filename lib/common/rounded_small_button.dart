import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallette.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const RoundedSmallButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = Pallette.whiteColor,
    this.textColor = Pallette.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(color: textColor, fontSize: 16.0),
        ),
        backgroundColor: backgroundColor,
        labelPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      ),
    );
  }
}
