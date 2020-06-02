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
    Firestore.instance
        .collection('images')
        .document(data.uid)
        .collection('process')
        .document(data.processName)
        .updateData({'deleteProcess': true});
    print('Deleted');
  }

  Future<void> _downloadImages({@required OutputData data}) async {
    final Directory tempDir = Directory.systemTemp;
    File iconContentFile;
    File iconStyleFile;
    List<File> iconOutputFiles = List<File>();
    List<Future<void>> getOps = List<Future<void>>();

    Future<void> _getFile({
      @required File file,
      @required String loc,
    }) async {
      if (!file.existsSync()) {
        file.createSync();
        await _stoRef.child(loc).writeToFile(file).future;
      }
    }

    iconContentFile =
        File('${tempDir.path}/${data.uid}${data.processName}_iconContent.jpg');
    iconStyleFile =
        File('${tempDir.path}/${data.uid}${data.processName}_iconStyle.jpg');

    getOps.addAll([
      _getFile(file: iconContentFile, loc: data.locIconContent),
      _getFile(file: iconStyleFile, loc: data.locIconStyle),
    ]);

    if (data.isProcessed) {
      data.locOutputs.forEach((key, value) {
        List<String> outputNameList = value.split('/').toList();
        String outputName = outputNameList[outputNameList.length - 1];
        File outputFile =
            File('${tempDir.path}/${data.uid}${data.processName}_$outputName');
        iconOutputFiles.add(outputFile);
        getOps.add(_getFile(file: outputFile, loc: value));
      });
    }

    await Future.wait(getOps).then((_) {});
  }

  _startProcess({@required OutputData data}) {
    Firestore.instance
        .collection('images')
        .document(data.uid)
        .updateData({'hasUnprocessedFlag': true});

    Firestore.instance
        .collection('images')
        .document(data.uid)
        .collection('process')
        .document(data.processName)
        .updateData({'startDate': DateTime.now()});

    Firestore.instance
        .collection('images')
        .document(data.uid)
        .collection('process')
        .document(data.processName)
        .updateData({
      'runOnUpload': true,
      'startDate': DateTime.now(),
    });
  }
}
