import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/theme/pallette.dart';

class TweetIconButton extends StatelessWidget {
  final String pathName;
  final String text;
  final VoidCallback onTap;
  const TweetIconButton({
    Key? key,
    required this.pathName,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            pathName,
            colorFilter: const ColorFilter.mode(
              Pallette.greyColor,
              BlendMode.srcIn,
            ),
            height: 20.0,
          ),
          Container(
            margin: const EdgeInsets.all(6),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
