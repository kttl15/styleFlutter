import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gan2/services/storage.dart';
import 'package:gan2/services/user_repo.dart';
import 'package:image/image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:meta/meta.dart';

class Uploader {
  Stream<StorageUploadTask> upload({
    @required bool createProcess,
    @required String processName,
    @required File image,
    @required bool isContent,
    bool runOnUpload,
    double epoch,
    double styleWeight,
    double contentWeight,
  }) async* {
    final FirebaseUser user = await UserRepo().getUser();
    final ImageStorageService _imageStorageService = ImageStorageService();
    final String uid = user.uid;
    final Directory tempDir = Directory.systemTemp;
    var iconImage = decodeImage(image.readAsBytesSync());
    var icon;
    if (iconImage.width > iconImage.height) {
      icon = copyResize(iconImage, width: 500);
    } else {
      icon = copyResize(iconImage, height: 500);
    }
    File('${tempDir.path}/icon.jpg').writeAsBytesSync(encodeJpg(icon));
    File iconFile = File('${tempDir.path}/icon.jpg');

    String contentLoc = 'images/$uid/$processName/content.jpg';
    String iconContentLoc = 'images/$uid/$processName/iconContent.jpg';
    String styleLoc = 'images/$uid/$processName/style.jpg';
    String iconStyleLoc = 'images/$uid/$processName/iconStyle.jpg';
    Map<String, dynamic> data;

    //* set flag to indicate unprocessed data
    await Firestore.instance
        .collection('images')
        .document(uid)
        .setData({'hasUnprocessedFlag': true});

    //* create process in database
    if (createProcess) {
      //* data for each process
      data = {
        'uid': uid,
        'processName': processName,
        'locContent': contentLoc,
        'locIconContent': iconContentLoc,
        'locStyle': styleLoc,
        'locIconStyle': iconStyleLoc,
        'locOutput': '',
        'locIconOutput': '',
        'uploadDate': DateTime.now(),
        'unprocessedFlag': true,
        'styleWeight': styleWeight,
        'contentWeight': contentWeight,
        'epoch': epoch,
        'runOnUpload': runOnUpload,
      };
      createProcessDoc(
        uid: uid,
        processName: processName,
        data: data,
      );
    }

    //* upload image to storage
    //TODO: upload icon sized images
    yield _imageStorageService
        .firebaseStorage()
        .ref()
        .child(isContent ? contentLoc : styleLoc)
        .putFile(image);

    _imageStorageService
        .firebaseStorage()
        .ref()
        .child(isContent ? iconContentLoc : iconStyleLoc)
        .putFile(iconFile);
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
