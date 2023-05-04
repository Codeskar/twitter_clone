import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallette.dart';

class FollowCount extends StatelessWidget {
  final int count;
  final String text;
  const FollowCount({
    super.key,
    required this.count,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            color: Pallette.whiteColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            color: Pallette.greyColor,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}