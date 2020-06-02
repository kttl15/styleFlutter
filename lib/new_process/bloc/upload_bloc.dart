import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gan2/new_process/uploader.dart';
import 'package:meta/meta.dart';
import 'dart:io';

import 'package:rxdart/rxdart.dart';

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
      if (!isValidProcessName) {
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
        yield ProcessNameUsedState(processName: event.processName);
      }
    } else if (event is Update) {
      yield* _mapUpdate(event1: event.event1);
    } else if (event is UploadCompleted) {
      yield* _mapUploadCompleted();
    }
  }

  Future<bool> _checkProcessName({String uid, String processName}) async {
    bool isProcessNameUsed = false;
    await Firestore.instance
        .collection('images')
        .document(uid)
        .collection('process')
        .getDocuments()
        .then((val) {
      val.documents.forEach((doc) {
        if (processName == doc.documentID) isProcessNameUsed = true;
      });
    });
    return isProcessNameUsed;
  }

  void _mapStartUpload({
    @required String processName,
    @required File contentFile,
    @required File styleFile,
    @required double styleWeight,
    @required double contentWeight,
    @required int epoch,
    @required bool runOnUpload,
  }) async {
    Stream<StorageUploadTask> storageUploadTask1 = Uploader().upload(
      //* upload content image and related settings
      createProcess: true,
      isContent: true,
      isIcon: false,
      image: contentFile,
      processName: processName,
      contentWeight: contentWeight,
      styleWeight: styleWeight,
      epoch: epoch,
      runOnUpload: runOnUpload,
    );

    Stream<StorageUploadTask> storageUploadTask2 = Uploader().upload(
      //* only upload style image
      createProcess: false,
      isContent: false,
      isIcon: false,
      image: styleFile,
      processName: processName,
    );

    Stream<StorageUploadTask> storageUploadTask3 = Uploader().upload(
      createProcess: false,
      processName: processName,
      image: contentFile,
      isContent: true,
      isIcon: true,
    );

    Stream<StorageUploadTask> storageUploadTask4 = Uploader().upload(
      createProcess: false,
      processName: processName,
      image: styleFile,
      isContent: false,
      isIcon: true,
    );
    // StorageTaskEvent event1;
    // StorageTaskEvent event2;
    // StorageTaskEvent event3;
    // StorageTaskEvent event4;

    // storageUploadTask1.asBroadcastStream().listen((event) {
    //   event.events.listen((event1) {
    //     storageUploadTask2.asBroadcastStream().listen((event) {
    //       event.events.listen((event2) {
    //         storageUploadTask3.asBroadcastStream().listen((event) {
    //           event.events.listen((event3) {
    //             storageUploadTask4.asBroadcastStream().listen((event) {
    //               event.events.listen((event4) {
    //                 add(Update(
    //                   event1: event1,
    //                   event2: event2,
    //                   event3: event3,
    //                   event4: event4,
    //                 ));
    //               });
    //             });
    //           });
    //         });
    //       });
    //     });
    //   });
    // });
    MergeStream<StorageUploadTask> streams = MergeStream<StorageUploadTask>([
      storageUploadTask1,
      storageUploadTask2,
      storageUploadTask3,
      storageUploadTask4,
    ]);

    streams.listen((event) {}).onDone(() {
      add(UploadCompleted());
    });

    // storageUploadTask2.listen((event) {
    //   event.events.listen((event) {
    //     // event2 = event;
    //   });
    // });

    // storageUploadTask3.listen((event) {
    //   event.events.listen((event) {
    //     // event3 = event;
    //   });
    // });

    // storageUploadTask4.listen((event) {
    //   event.events.listen((event) {
    //     // event4 = event;
    //   });
    // });

    // add(Update(event1: event1, event2: event2, event3: event3, event4: event4));
  }

  Stream<UploadState> _mapUpdate({
    @required StorageTaskEvent event1,
  }) async* {
    yield InProgress(event1: event1);
  }

  Stream<UploadState> _mapUploadCompleted() async* {
    yield Completed();
  }
}
