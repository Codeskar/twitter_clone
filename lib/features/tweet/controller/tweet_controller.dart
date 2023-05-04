import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/notifications/controller/notification_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';

import '../../../apis/storage_api.dart';
import '../../../core/enums/tweet_type_enum.dart';
import '../../../models/user_model.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) => TweetController(
    ref: ref,
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageApiProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  ),
);

final tweetListProvider = FutureProvider<List<Tweet>>((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final repliesToTweetProvider = FutureProvider.family((ref, Tweet tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesToTweet(tweet);
});

final getLatestTweetProvider = StreamProvider((ref) {
  final tweetApi = ref.watch(tweetAPIProvider);
  return tweetApi.getLatestTweet();
});

final getTweetByIdProvider = FutureProvider.family((ref, String tweetId) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(tweetId);
});

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final NotificationController _notificationController;
  final Ref _ref;
  TweetController(
      {required Ref ref,
      required TweetAPI tweetAPI,
      required StorageAPI storageAPI,
      required NotificationController notificationController})
      : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<Tweet> getTweetById(String tweetId) async {
    final tweet = await _tweetAPI.getTweetById(tweetId);
    return Tweet.fromMap(tweet.data);
  }

  void likeTweet({
    required Tweet tweet,
    required UserModel user,
  }) async {
    List<String> likes = tweet.likes;
    if (tweet.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetAPI.likeTweet(tweet);
    res.fold((l) => print(l.message), (r) {
      _notificationController.createNotification(
        text: '${user.name} liked your tweet',
        postId: tweet.id,
        notificationType: NotificationType.like,
        userId: tweet.userId,
      );
    });
  }

  void reshareTweet({
    required Tweet tweet,
    required UserModel currentUser,
    required BuildContext context,
  }) async {
    tweet = tweet.copyWith(
      retweetedBy: currentUser.name,
      likes: [],
      commentIds: [],
      resharedCount: tweet.resharedCount + 1,
    );

    final res = await _tweetAPI.updateReshareCount(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      tweet = tweet.copyWith(
        id: ID.unique(),
        resharedCount: 0,
        tweetedAt: DateTime.now(),
      );
      final res2 = await _tweetAPI.shareTweet(tweet);
      res2.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          _notificationController.createNotification(
            text: '${currentUser.name} retweeted your tweet!',
            postId: tweet.id,
            notificationType: NotificationType.retweet,
            userId: tweet.userId,
          );
          showSnackBar(context, 'Retweeted!');
        },
      );
    });
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter some text');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    } else {
      _shareTextTweet(
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    }
  }

  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHashTagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImages(files: images);

    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      userId: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      resharedCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );

    final res = await _tweetAPI.shareTweet(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.name} replied to your tweet',
          postId: r.$id,
          notificationType: NotificationType.reply,
          userId: repliedToUserId,
        );
      }
    });
    state = false;
  }

  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHashTagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;

    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      userId: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      resharedCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );

    final res = await _tweetAPI.shareTweet(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.name} replied to your tweet',
          postId: r.$id,
          notificationType: NotificationType.reply,
          userId: repliedToUserId,
        );
      }
    });
    state = false;
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final tweetList = await _tweetAPI.getRepliesToTweet(tweet);
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> words = text.split(' ');
    for (String word in words) {
      if (word.startsWith('https://') ||
          word.startsWith('http://') ||
          word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashTagsFromText(String text) {
    List<String> hashTags = [];
    List<String> words = text.split(' ');
    for (String word in words) {
      if (word.startsWith('#')) {
        hashTags.add(word);
      }
    }
    return hashTags;
  }
}
