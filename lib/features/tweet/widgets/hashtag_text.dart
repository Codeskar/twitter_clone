import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallette.dart';

class HashtagText extends StatelessWidget {
  final String text;
  const HashtagText({
    Key? key,
    required this.text,
  }) : super(key: key);

  List<TextSpan> getSpans() {
    List<TextSpan> textSpans = [];
    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textSpans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallette.blueColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (element.startsWith('www.') ||
          element.startsWith('https://') ||
          element.startsWith('http://')) {
        textSpans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallette.blueColor,
              fontSize: 18,
            ),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        );
      }
    });
    return textSpans;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: getSpans(),
      ),
    );
  }
}
