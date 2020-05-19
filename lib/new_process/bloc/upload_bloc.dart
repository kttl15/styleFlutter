import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gan2/new_process/uploader.dart';
import 'package:meta/meta.dart';
import 'dart:io';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  @override
  UploadState get initialState => Initial();

  @override
  Stream<UploadState> mapEventToState(UploadEvent event) async* {
    if (event is RevertToInit) {
      yield Initial();
    }
    if (event is StartUpload) {
      bool isValidProcessName = await _checkProcessName(
        uid: event.uid,
        processName: event.processName,
      );
      if (isValidProcessName) {
        _mapStartUpload(
          processName: event.processName,
          contentFile: event.contentFile,
          styleFile: event.styleFile,
          styleWeight: event.styleWeight,
          contentWeight: event.contentWeight,
          epoch: event.epoch,
          runOnUpload: event.runOnUpload,
        );
      } else {
        yield InvalidProcessName(processName: event.processName);
      }
    } else if (event is Update) {
      yield* _mapUpdate(task: event.task);
    } else if (event is UploadCompleted) {
      yield* _mapUploadCompleted();
    }
  }

  Future<bool> _checkProcessName({String uid, String processName}) async {
    bool isValidProcessName = true;
    await Firestore.instance
        .collection('images')
        .document(uid)
        .collection('process')
        .getDocuments()
        .then((val) {
      val.documents.forEach((doc) {
        if (processName == doc.documentID) isValidProcessName = false;
      });
    });
    return isValidProcessName;
  }

  void _mapStartUpload({
    @required String processName,
    @required File contentFile,
    @required File styleFile,
    @required double styleWeight,
    @required double contentWeight,
    @required double epoch,
    @required bool runOnUpload,
  }) {
    Uploader upload1 = Uploader();
    Uploader upload2 = Uploader();
    Stream<StorageUploadTask> storageUploadTask1;
    Stream<StorageUploadTask> storageUploadTask2;
    storageUploadTask1 = upload1.upload(
      //* upload content image and related settings
      createProcess: true,
      isContent: true,
      image: contentFile,
      processName: processName,
      contentWeight: contentWeight,
      styleWeight: styleWeight,
      epoch: epoch,
      runOnUpload: runOnUpload,
    );

    storageUploadTask2 = upload2.upload(
      //* only upload style image
      createProcess: false,
      isContent: false,
      image: styleFile,
      processName: processName,
    );
    storageUploadTask1.listen((val) {
      val.events.listen((val) {
        switch (val.type.index) {
          case 0:
            //* resume
            break;
          case 1:
            //* in progress
            return add(Update(task: val));
            break;
          case 2:
            //* paused
            break;
          case 3:
            //* success
            return add(UploadCompleted());
            break;
          case 4:
            //* failed
            break;
        }
      });
    });

    storageUploadTask2.listen((_) {});
  }

  Stream<UploadState> _mapUpdate({
    @required StorageTaskEvent task,
  }) async* {
    yield InProgress(task: task);
  }

  Stream<UploadState> _mapUploadCompleted() async* {
    yield Completed();
  }
}
