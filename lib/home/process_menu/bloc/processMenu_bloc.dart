import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gan2/model/data.dart';
import 'package:meta/meta.dart';

part 'processMenu_event.dart';
part 'processMenu_state.dart';

class ProcessMenuBloc extends Bloc<ProcessMenuEvent, ProcessMenuState> {
  final StorageReference _stoRef = FirebaseStorage.instance.ref();

  @override
  ProcessMenuState get initialState => ProcessMenuInitial();

  @override
  Stream<ProcessMenuState> mapEventToState(ProcessMenuEvent event) async* {
    if (event is DownloadImagesEvent) {
      await _downloadImages(data: event.data);
      yield ImageDownloadedState(data: event.data);
    } else if (event is DeleteProcessEvent) {
      _deleteProcess(data: event.data);
    } else if (event is StartProcessEvent) {
      _startProcess(data: event.data);
    }
  }

  _deleteProcess({@required OutputData data}) async {
    final String path = 'images/${data.uid}/${data.processName}/';
    // print(path);
    Firestore.instance
        .collection('images')
        .document(data.uid)
        .collection('process')
        .document(data.processName)
        .delete();
    try {
      _stoRef.child(path + 'content.jpg').delete();
    } catch (_) {}
    try {
      _stoRef.child(path + 'iconContent.jpg').delete();
    } catch (_) {}
    try {
      _stoRef.child(path + 'style.jpg').delete();
    } catch (_) {}
    try {
      _stoRef.child(path + 'iconStyle.jpg').delete();
    } catch (_) {}
    try {
      _stoRef.child(path + 'output.jpg').delete();
    } catch (_) {}
    try {
      _stoRef.child(path + 'iconOutput.jpg').delete();
    } catch (_) {}
    print('Deleted');
  }

  Future<void> _downloadImages({@required OutputData data}) async {
    final Directory tempDir = Directory.systemTemp;
    File iconContentFile;
    File iconStyleFile;
    // File iconOutputFile;
    //TODO: implement output file
    iconContentFile =
        File('${tempDir.path}/${data.uid}${data.processName}_iconContent.jpg');
    iconStyleFile =
        File('${tempDir.path}/${data.uid}${data.processName}_iconStyle.jpg');

    Future<void> _getContent() async {
      if (!iconContentFile.existsSync()) {
        iconContentFile.createSync();
        await _stoRef
            .child(data.locIconContent)
            .writeToFile(iconContentFile)
            .future;
      }
    }

    Future<void> _getStyle() async {
      if (!iconStyleFile.existsSync()) {
        iconStyleFile.createSync();
        await _stoRef
            .child(data.locIconStyle)
            .writeToFile(iconStyleFile)
            .future;
      }
    }

    await Future.wait([_getContent(), _getStyle()]).then((val) {});
  }

  _startProcess({@required OutputData data}) {
    //* update hasUnprocessedFlag
    Firestore.instance
        .collection('images')
        .document(data.uid)
        .updateData({'hasUnprocessedFlag': true});

    //* update runOnUpload flag
    Firestore.instance
        .collection('images')
        .document(data.uid)
        .collection('process')
        .document(data.processName)
        .updateData({'runOnUpload': true});
  }
}
