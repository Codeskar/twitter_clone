import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/pallette.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../common/common.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(tweet.userId)).when(
          data: (tweetAuthor) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 35.0,
                        backgroundImage: NetworkImage(tweetAuthor.profilePic),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //retweet
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5.0),
                                child: Text(
                                  tweetAuthor.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19.0,
                                  ),
                                ),
                              ),
                              Text(
                                '@${tweetAuthor.name} • ${timeago.format(
                                  tweet.tweetedAt,
                                  locale: 'en_short',
                                )}',
                                style: const TextStyle(
                                  fontSize: 17.0,
                                  color: Pallette.greyColor,
                                ),
                              ),
                            ],
                          ),
                          //replied to
                          HashtagText(text: tweet.text),
                          if (tweet.tweetType == TweetType.image)
                            CarouselImage(
                              imageLinks: tweet.imageLinks,
                            ),
                          if (tweet.link.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            AnyLinkPreview(
                              displayDirection:
                                  UIDirection.uiDirectionHorizontal,
                              link: 'https://${tweet.link}',
                            ),
                          ],
                          Container(
                            margin: const EdgeInsets.only(
                              top: 10.0,
                              right: 20.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TweetIconButton(
                                  pathName: AssetsConstants.viewsIcon,
                                  text: (tweet.commentIds.length +
                                          tweet.resharedCount +
                                          tweet.likes.length)
                                      .toString(),
                                  onTap: () {},
                                ),
                                TweetIconButton(
                                  pathName: AssetsConstants.commentIcon,
                                  text: tweet.commentIds.length.toString(),
                                  onTap: () {},
                                ),
                                TweetIconButton(
                                  pathName: AssetsConstants.retweetIcon,
                                  text: tweet.resharedCount.toString(),
                                  onTap: () {},
                                ),
                                TweetIconButton(
                                  pathName: AssetsConstants.likeOutlinedIcon,
                                  text: tweet.likes.length.toString(),
                                  onTap: () {},
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share,
                                    size: 25.0,
                                    color: Pallette.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 1),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Pallette.greyColor)
              ],
            );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
