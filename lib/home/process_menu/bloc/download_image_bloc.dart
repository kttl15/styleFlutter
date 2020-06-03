import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

part 'download_image_event.dart';
part 'download_image_state.dart';

class DownloadImageBloc extends Bloc<DownloadImageEvent, DownloadImageState> {
  @override
  DownloadImageState get initialState => DownloadImageInitial();

  @override
  Stream<DownloadImageState> mapEventToState(
    DownloadImageEvent event,
  ) async* {
    if (event is ImageDownloadEvent) {
      yield ImageDownloading();
      await _downloadImage(
        file: event.file,
        loc: event.loc,
      );

      yield ImageDownloaded();
    }
  }

  Future<void> _downloadImage({
    @required String loc,
    @required File file,
  }) async {
    if (!file.existsSync() || file.readAsBytesSync().length == 0) {
      // if file does not exist or file size is 0 bytes
      file.createSync();
      await FirebaseStorage.instance.ref().child(loc).writeToFile(file).future;
    }
  }
}
