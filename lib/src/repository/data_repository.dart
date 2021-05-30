import 'dart:io';

import 'package:cie_photo_clash/src/blocs/data/api_response.dart';
import 'package:cie_photo_clash/src/model/cie_user.dart';
import 'package:cie_photo_clash/src/model/like.dart';
import 'package:cie_photo_clash/src/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class StorageException implements Exception {
  final String message;

  StorageException({required this.message});
}

class DataRepository {
  Future<ApiResponse> savePostImage(
      {required String uid, required File photo}) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}.jpg';

      var file = await FlutterImageCompress.compressAndGetFile(
        photo.absolute.path,
        tempPath,
        quality: 50,
      );
      var firebaseStorage = FirebaseStorage.instance
          .ref('post_images/$uid${DateTime.now().millisecondsSinceEpoch}');
      await firebaseStorage.putFile(file!);
      String url = await firebaseStorage.getDownloadURL();

      return ApiResponse(data: url, error: false);
    } on FirebaseException catch (e) {
      print('Strorage Error:${e.message}');
      return ApiResponse(data: e.message, error: true);
    }
  }

  Future<ApiResponse> user(String uid) async {
    try {
      var documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return ApiResponse(
          data: CIEUser.fromMap(documentSnapshot.data()!), error: false);
    } on FirebaseException catch (e) {
      return ApiResponse(data: e.message, error: true);
    }
  }

  Stream<CIEUser> userDetails(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((doc) => CIEUser.fromMap(doc.data()!));
  }

  Future<ApiResponse> users() async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection("users").get();
      return ApiResponse(
          data: querySnapshot.docs
              .map((doc) => CIEUser.fromMap(doc.data()))
              .toList(),
          error: false);
    } on FirebaseException catch (e) {
      return ApiResponse(data: e.message, error: true);
    }
  }

  Future<ApiResponse> searchUsers(String query, {required String uid}) async {
    print(query);
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection("users").get();
      // print(querySnapshot.docs.length);
      ApiResponse(
          data: querySnapshot.docs
              .map((doc) => CIEUser.fromMap(doc.data()))
              .toList(),
          error: false);
      return ApiResponse(
          data: querySnapshot.docs
              .map((doc) => CIEUser.fromMap(doc.data()))
              .where((user) =>
                  user.name.toLowerCase().startsWith(query.toLowerCase()))
              .where((user) => uid != user.id)
              .toList(),
          error: false);
    } on FirebaseException catch (e) {
      return ApiResponse(data: e.message, error: true);
    }
  }

  Future<ApiResponse> savePost(Post post,
      {required String uid, required File photo}) async {
    try {
      var documentReference =
          FirebaseFirestore.instance.collection("posts").doc();

      var apiResponse =
          await savePostImage(uid: documentReference.id, photo: photo);
      if (!apiResponse.error) {
        await documentReference.set(post
            .copyWith(id: documentReference.id, imagePath: apiResponse.data)
            .toMap());
        return ApiResponse(data: 'Success', error: false);
      } else {
        return ApiResponse(data: 'Failed to upload image', error: true);
      }
    } on FirebaseException catch (e) {
      return ApiResponse(data: e.message, error: true);
    }
  }

  Stream<List<Post>> posts({page}) {
    return FirebaseFirestore.instance
        .collection("posts")
        // .where('status', isEqualTo: 'completed')
        .orderBy('timestamp', descending: true)
        // .startAt(page)
        // .limit(5)
        .snapshots()
        .asyncMap((snapshots) async {
      return await convertSnapshots(snapshots);
    });
  }

  Future<List<Post>> convertSnapshots(QuerySnapshot snapshots) async {
    return snapshots.docs.map((doc) {
      return Post.fromMap(doc.data());
    }).toList();
  }

  Future<ApiResponse> addUserToB(CIEUser user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toMap());

      return ApiResponse(data: user, error: false);
    } on FirebaseAuthException catch (e) {
      return ApiResponse(data: e.message, error: true);
    }
  }

  Stream<List<Like>> likes(String postId) {
    return FirebaseFirestore.instance
        .collection("post_likes")
        .doc(postId)
        .collection('likes')
        .where('postId', isEqualTo: '$postId')
        .snapshots()
        .asyncMap((snapshots) async {
      return await convertLikeSnapshots(snapshots);
    });
  }

  Future<void> addLike(Like like) async {
    try {
      var ref = FirebaseFirestore.instance
          .collection('post_likes')
          .doc(like.postId)
          .collection('likes')
          .doc();
      await ref.set(like.copyWith(id: ref.id).toMap());
    } on FirebaseException catch (e) {
      print('Add Like Error:${e.message}');
    }
  }

  Future<void> unLike(String uid, String postId) async {
    try {
      await FirebaseFirestore.instance
          .collection('post_likes')
          .doc(postId)
          .collection('likes')
          .doc(uid)
          .delete();
    } on FirebaseException catch (e) {
      print('Remove Unlike Error:${e.message}');
      return null;
    }
  }

  Future<List<Like>> convertLikeSnapshots(QuerySnapshot snapshots) async {
    return snapshots.docs.map((doc) {
      return Like.fromMap(doc.data());
    }).toList();
  }
}
