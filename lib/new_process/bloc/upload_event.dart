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
  final double epoch;
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
  final StorageTaskEvent task;

  Update({@required this.task});

  double _transferred() {
    return (task.snapshot.bytesTransferred / 1024).roundToDouble();
  }

  @override
  List<Object> get props => [task];

  @override
  String toString() => 'Tick ${_transferred()}kB';
}

class UploadCompleted extends UploadEvent {
  @override
  String toString() => 'Upload Completed';
}

class ExitUpload extends UploadEvent {}
