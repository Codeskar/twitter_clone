import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/models/notification_model.dart';
import 'package:twitter_clone/theme/pallette.dart';

import '../../../core/enums/notification_type_enum.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(
              Icons.person,
              color: Pallette.blueColor,
            )
          : notification.notificationType == NotificationType.like
              ? SvgPicture.asset(
                  AssetsConstants.likeFilledIcon,
                  colorFilter: const ColorFilter.mode(
                    Pallette.redColor,
                    BlendMode.srcIn,
                  ),
                  height: 20,
                )
              : notification.notificationType == NotificationType.retweet
                  ? SvgPicture.asset(
                      AssetsConstants.retweetIcon,
                      colorFilter: const ColorFilter.mode(
                        Pallette.whiteColor,
                        BlendMode.srcIn,
                      ),
                      height: 20,
                    )
                  : null,
      title: Text(notification.text),
    );
  }
}
