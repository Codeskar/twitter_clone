import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';

import '../../../common/common.dart';
import '../../../constants/constants.dart';
import '../../../models/tweet_model.dart';

class ReplyView extends ConsumerWidget {
  static route({required Tweet tweet}) =>
      MaterialPageRoute(builder: (_) => ReplyView(tweet: tweet));
  final Tweet tweet;
  const ReplyView({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tweet'),
        ),
        body: Column(
          children: [
            TweetCard(tweet: tweet),
            ref.watch(repliesToTweetProvider(tweet)).when(
                  data: (tweets) {
                    return ref.watch(getLatestTweetProvider).when(
                          data: (data) {
                            final latestTweet = Tweet.fromMap(data.payload);
                            bool isTweetAlreadyPresent = false;
                            for (final tweetModel in tweets) {
                              if (tweetModel.id == latestTweet.id) {
                                isTweetAlreadyPresent = true;
                                break;
                              }
                            }
                            if (!isTweetAlreadyPresent &&
                                latestTweet.repliedTo == tweet.id) {
                              if (data.events.contains(
                                // change this to specific database when production ready
                                'databases.*.collections.${AppwriteConstants.tweetCollectionId}.documents.*.create',
                              )) {
                                tweets.insert(0, Tweet.fromMap(data.payload));
                              } else if (data.events.contains(
                                  // change this to specific database when production ready
                                  'databases.*.collections.${AppwriteConstants.tweetCollectionId}.documents.*.update')) {
                                final startingPoint =
                                    data.events[0].lastIndexOf('documents.');
                                final endPoint =
                                    data.events[0].lastIndexOf('.update');
                                final tweetId = data.events[0]
                                    .substring(startingPoint + 10, endPoint);

                                Tweet tweet = tweets.firstWhere(
                                    (element) => element.id == tweetId);

                                final tweetIndex = tweets.indexOf(tweet);
                                tweets.removeWhere(
                                    (element) => element.id == tweetId);

                                tweet = Tweet.fromMap(data.payload);
                                tweets.insert(tweetIndex, tweet);
                              }
                            }

                            return Expanded(
                              child: ListView.builder(
                                itemCount: tweets.length,
                                itemBuilder: (context, index) {
                                  final tweet = tweets[index];
                                  return TweetCard(tweet: tweet);
                                },
                              ),
                            );
                          },
                          error: (error, st) => ErrorText(
                            error: error.toString(),
                          ),
                          loading: () {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: tweets.length,
                                itemBuilder: (context, index) {
                                  final tweet = tweets[index];
                                  return TweetCard(tweet: tweet);
                                },
                              ),
                            );
                          },
                        );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          ],
        ),
        bottomNavigationBar: TextField(
          onSubmitted: (value) {
            ref.read(tweetControllerProvider.notifier).shareTweet(
              images: [],
              text: value,
              context: context,
              repliedTo: tweet.id,
              repliedToUserId: tweet.userId,
            );
          },
          decoration: InputDecoration(
            hintText: 'Tweet your reply',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {},
            ),
          ),
        ));
  }
}
