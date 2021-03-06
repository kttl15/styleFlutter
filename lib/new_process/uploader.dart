import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gan2/services/storage.dart';
import 'package:gan2/services/user_repo.dart';
import 'package:image/image.dart';
import 'package:meta/meta.dart';

class Uploader {
  Stream<StorageUploadTask> upload({
    @required bool createProcess,
    @required String processName,
    @required File image,
    @required bool isContent,
    @required bool isIcon,
    bool runOnUpload,
    int epoch,
    double styleWeight,
    double contentWeight,
  }) async* {
    final FirebaseUser user = await UserRepo().getUser();
    final ImageStorageService _imageStorageService = ImageStorageService();
    final String uid = user.uid;
    String contentLoc = 'images/$uid/$processName/content.jpg';
    String iconContentLoc = 'images/$uid/$processName/iconContent.jpg';
    String styleLoc = 'images/$uid/$processName/style.jpg';
    String iconStyleLoc = 'images/$uid/$processName/iconStyle.jpg';

    if (!isIcon) {
      if (isContent) {
        assert(contentWeight != null);
        assert(styleWeight != null);
        assert(epoch != null);
        assert(runOnUpload != null);
        Map<String, dynamic> data;

        //* set flag to indicate unprocessed data
        await Firestore.instance
            .collection('images')
            .document(uid)
            .setData({'hasUnprocessedFlag': true});

        data = {
          'uid': uid,
          'processName': processName,
          'locContent': contentLoc,
          'locIconContent': iconContentLoc,
          'locStyle': styleLoc,
          'locIconStyle': iconStyleLoc,
          'locOutputs': {'1': ''},
          'locIconOutputs': {'1': ''},
          'uploadDate': DateTime.now(),
          'isProcessed': false,
          'styleWeight': styleWeight,
          'contentWeight': contentWeight,
          'epoch': epoch,
          'runOnUpload': runOnUpload,
          'startDate': runOnUpload ? DateTime.now() : '',
          'deleteProcess': false,
        };

        createProcessDoc(
          uid: uid,
          processName: processName,
          data: data,
        );

        yield _imageStorageService
            .firebaseStorage()
            .ref()
            .child(contentLoc)
            .putFile(image);
      } else {
        //* upload image to storage
        yield _imageStorageService
            .firebaseStorage()
            .ref()
            .child(styleLoc)
            .putFile(image);
      }
    } else {
      final Directory tempDir = Directory.systemTemp;
      File iconFile;

      if (image.readAsBytesSync().lengthInBytes >= 300000) {
        var iconImage = decodeImage(image.readAsBytesSync());
        var icon;
        // print([iconImage.width, iconImage.height]);
        if (iconImage.width > iconImage.height) {
          icon = copyResize(iconImage, width: 500);
        } else {
          icon = copyResize(iconImage, height: 500);
        }
        File('${tempDir.path}/icon.jpg').writeAsBytesSync(encodeJpg(icon));
        iconFile = File('${tempDir.path}/icon.jpg');
      } else {
        iconFile = image;
      }

      yield _imageStorageService
          .firebaseStorage()
          .ref()
          .child(isContent ? iconContentLoc : iconStyleLoc)
          .putFile(iconFile);
    }
  }

  Future<void> createProcessDoc({
    @required String uid,
    @required String processName,
    @required Map<String, dynamic> data,
  }) async {
    await Firestore.instance
        .collection('images')
        .document(uid)
        .collection('process')
        .document(processName)
        .setData(data);
  }
}
