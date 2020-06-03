import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gan2/model/data.dart';
import 'package:meta/meta.dart';

part 'processtile_event.dart';
part 'processtile_state.dart';

class ProcessTileBloc extends Bloc<ProcessTileEvent, ProcessTileState> {
  @override
  ProcessTileState get initialState => ProcessTileInitial();

  @override
  Stream<ProcessTileState> mapEventToState(
    ProcessTileEvent event,
  ) async* {
    if (event is DownloadOutputEvent) {
      yield OutputImageLoading();
      bool outputImageDownloaded = await _downloadOutputIcon(data: event.data);
      if (outputImageDownloaded)
        yield OutputImageDownloadedState(data: event.data);
      else
        yield OutputImageNotAvailableState();
    }
  }

  Future<bool> _downloadOutputIcon({@required OutputData data}) async {
    final Directory tempDir = Directory.systemTemp;
    File iconOutputFile;
    iconOutputFile =
        File('${tempDir.path}/${data.uid}${data.processName}_iconOutput.jpg');
    // print(iconOutputFile.path);
    if (!iconOutputFile.existsSync() ||
        iconOutputFile.readAsBytesSync().length == 0) {
      iconOutputFile.createSync();

      await FirebaseStorage.instance
          .ref()
          .child(data.locIconContent) //! change to data.locIconOutput
          .writeToFile(iconOutputFile)
          .future;
      return true;
    } else {
      return true;
    }
  }
}
