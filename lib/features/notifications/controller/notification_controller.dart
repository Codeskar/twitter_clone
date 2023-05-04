import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/notification_api.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';

import '../../../models/notification_model.dart';

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, bool>(
  (ref) => NotificationController(
    notificationAPI: ref.watch(notificationApiProvider),
  ),
);

final getLatestNotificationProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(notificationApiProvider).getLatestNotification(),
);

final getNotificationsProvider = FutureProvider.family(
  (ref, String userId) async => await ref
      .watch(notificationControllerProvider.notifier)
      .getNotifications(userId),
);

class NotificationController extends StateNotifier<bool> {
  final NotificationAPI _notificationAPI;
  NotificationController({required NotificationAPI notificationAPI})
      : _notificationAPI = notificationAPI,
        super(false);

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String userId,
  }) async {
    final notification = NotificationModel(
      text: text,
      postId: postId,
      notificationType: notificationType,
      userId: userId,
      id: '',
    );

    final res = await _notificationAPI.createNotification(notification);
    res.fold((l) => print(l.message), (r) => null);
  }

  Future<List<NotificationModel>> getNotifications(String userId) async {
    final notifications = await _notificationAPI.getNotifications(userId);
    return notifications.map((e) => NotificationModel.fromMap(e.data)).toList();
  }
}
