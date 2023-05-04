import 'package:twitter_clone/core/enums/notification_type_enum.dart';

class NotificationModel {
  final String text;
  final String postId;
  final String id;
  final String userId;
  final NotificationType notificationType;
  NotificationModel({
    required this.text,
    required this.postId,
    required this.id,
    required this.userId,
    required this.notificationType,
  });

  NotificationModel copyWith({
    String? text,
    String? postId,
    String? id,
    String? userId,
    NotificationType? notificationType,
  }) {
    return NotificationModel(
      text: text ?? this.text,
      postId: postId ?? this.postId,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'postId': postId,
      'userId': userId,
      'notificationType': notificationType.type,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      text: map['text'] as String,
      postId: map['postId'] as String,
      id: map['\$id'] as String,
      userId: map['userId'] as String,
      notificationType:
          (map['notificationType'] as String).toNotificationTypeEnum(),
    );
  }

  @override
  String toString() {
    return 'Notification(text: $text, postId: $postId, id: $id, userId: $userId, notificationType: $notificationType)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.postId == postId &&
        other.id == id &&
        other.userId == userId &&
        other.notificationType == notificationType;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        postId.hashCode ^
        id.hashCode ^
        userId.hashCode ^
        notificationType.hashCode;
  }
}
