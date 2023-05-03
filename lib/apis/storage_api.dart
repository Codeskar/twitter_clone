import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/providers.dart';

final storageApiProvider = Provider((ref) {
  return StorageAPI(storage: ref.watch(appwriteStorageProvider));
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImages({
    required List<File> files,
  }) async {
    final List<String> fileUrls = [];
    for (final file in files) {
      final response = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      fileUrls.add(
        AppwriteConstants.imageUrl(response.$id),
      );
    }
    return fileUrls;
  }
}
