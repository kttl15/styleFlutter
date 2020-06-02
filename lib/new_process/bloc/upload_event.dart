part of 'upload_bloc.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();
  @override
  List<Object> get props => [];
}

class RevertToInit extends UploadEvent {}

class StartUpload extends UploadEvent {
  final String uid;
  final String processName;
  final File contentFile;
  final File styleFile;
  final double styleWeight;
  final double contentWeight;
  final int epoch;
  final bool runOnUpload;

  StartUpload({
    @required this.uid,
    @required this.processName,
    @required this.contentFile,
    @required this.styleFile,
    @required this.styleWeight,
    @required this.contentWeight,
    @required this.epoch,
    @required this.runOnUpload,
  });
  @override
  String toString() => 'Upload Started';
}

class Update extends UploadEvent {
  final StorageTaskEvent event1;
  final StorageTaskEvent event2;
  final StorageTaskEvent event3;
  final StorageTaskEvent event4;

  Update({this.event1, this.event2, this.event3, this.event4});
  // int _totalBytes() {
  //   return event1.snapshot.bytesTransferred +
  //       event2.snapshot.bytesTransferred +
  //       event3.snapshot.bytesTransferred +
  //       event4.snapshot.bytesTransferred;
  // }

  double _transferred() {
    return (event1.snapshot.bytesTransferred / 1024).roundToDouble();
  }

  @override
  List<Object> get props => [event1, event2, event3, event4];

  @override
  String toString() => 'Tick ${_transferred()}kB';
}

class UploadCompleted extends UploadEvent {
  @override
  String toString() => 'Upload Completed';
}

class ExitUpload extends UploadEvent {}
