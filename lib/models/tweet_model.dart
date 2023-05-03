// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import 'package:twitter_clone/core/enums/tweet_type_enum.dart';

@immutable
class Tweet {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imageLinks;
  final String userId;
  final TweetType tweetType;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  final int resharedCount;
  const Tweet({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imageLinks,
    required this.userId,
    required this.tweetType,
    required this.tweetedAt,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.resharedCount,
  });

  Tweet copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    List<String>? imageLinks,
    String? userId,
    TweetType? tweetType,
    DateTime? tweetedAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    int? resharedCount,
  }) {
    return Tweet(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      userId: userId ?? this.userId,
      tweetType: tweetType ?? this.tweetType,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      resharedCount: resharedCount ?? this.resharedCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'hashtags': hashtags,
      'link': link,
      'imageLinks': imageLinks,
      'userId': userId,
      'tweetType': tweetType.type,
      'tweetedAt': tweetedAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'resharedCount': resharedCount,
    };
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map['text'] as String,
      hashtags: List<String>.from((map['hashtags'] as List)),
      link: map['link'] as String,
      imageLinks: List<String>.from((map['imageLinks'] as List)),
      userId: map['userId'] as String,
      tweetType: (map['tweetType'] as String).toTweetTypeEnum(),
      tweetedAt: DateTime.fromMillisecondsSinceEpoch(map['tweetedAt'] as int),
      likes: List<String>.from((map['likes'] as List)),
      commentIds: List<String>.from((map['commentIds'] as List)),
      id: map['\$id'] as String,
      resharedCount: map['resharedCount'] as int,
    );
  }

  @override
  String toString() {
    return 'Tweet(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, userId: $userId, tweetType: $tweetType, tweetedAt: $tweetedAt, likes: $likes, commentIds: $commentIds, id: $id, resharedCount: $resharedCount)';
  }

  @override
  bool operator ==(covariant Tweet other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.userId == userId &&
        other.tweetType == tweetType &&
        other.tweetedAt == tweetedAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.id == id &&
        other.resharedCount == resharedCount;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashtags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        userId.hashCode ^
        tweetType.hashCode ^
        tweetedAt.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        id.hashCode ^
        resharedCount.hashCode;
  }
}
