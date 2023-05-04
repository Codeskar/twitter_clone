import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/features/notifications/controller/notification_controller.dart';
import 'package:twitter_clone/models/user_model.dart';

import '../../../apis/tweet_api.dart';
import '../../../apis/user_api.dart';
import '../../../core/enums/notification_type_enum.dart';
import '../../../core/utils.dart';
import '../../../models/tweet_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageApiProvider),
    userAPI: ref.watch(userAPIProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final userTweetsProvider = FutureProvider.family((ref, String userId) async {
  final controller = ref.watch(userProfileControllerProvider.notifier);
  return controller.getUserTweets(userId);
});

final getLatestUserProfileProvider = StreamProvider((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatesUserProfile();
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  final NotificationController _notificationController;
  UserProfileController(
      {required tweetAPI,
      required storageAPI,
      required userAPI,
      required notificationController})
      : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<Tweet>> getUserTweets(String userId) async {
    final tweets = await _tweetAPI.getUserTweets(userId);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileImageFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageAPI.uploadImages(files: [bannerFile]);
      userModel = userModel.copyWith(bannerPic: bannerUrl.first);
    }

    if (profileImageFile != null) {
      final profileImageUrl =
          await _storageAPI.uploadImages(files: [profileImageFile]);
      userModel = userModel.copyWith(profilePic: profileImageUrl.first);
    }

    final res = await _userAPI.updateUser(userModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }

  void followUser({
    required UserModel userToFollow,
    required UserModel currentUser,
    required BuildContext context,
  }) async {
    if (currentUser.following.contains(userToFollow.uid)) {
      currentUser.following.remove(userToFollow.uid);
      userToFollow.followers.remove(currentUser.uid);
    } else {
      currentUser.following.add(userToFollow.uid);
      userToFollow.followers.add(currentUser.uid);
    }

    userToFollow = userToFollow.copyWith(followers: userToFollow.followers);
    currentUser = currentUser.copyWith(following: currentUser.following);

    final res = await _userAPI.followUser(userToFollow);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        final res2 = await _userAPI.addToFollowing(currentUser);
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            _notificationController.createNotification(
              text: '${currentUser.name} followed you',
              postId: '',
              notificationType: NotificationType.follow,
              userId: userToFollow.uid,
            );
          },
        );
      },
    );
  }
}
