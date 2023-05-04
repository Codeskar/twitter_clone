class AppwriteConstants {
  //core
  static const String databaseId = '64518736920711cc8d50';
  static const String projectId = '6451852fe7664f0e5ca1';
  static const String endpoint = 'https://cloud.appwrite.io/v1';

  //collections
  static const String userCollectionId = '64528522bb547020ba4e';
  static const String tweetCollectionId = '6452b7cde5dc9ae21194';
  static const String notificationCollectionId = '6453feb8616bb9a6fd43';

  //buckets
  static const String imagesBucketId = '6452bfbb28d2dea2c7af';

  //functions
  static String imageUrl(String fileId) {
    return '$endpoint/storage/buckets/$imagesBucketId/files/$fileId/view?project=$projectId&mode=admin';
  }
}
