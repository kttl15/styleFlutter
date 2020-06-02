part of 'upload_bloc.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

class Initial extends UploadState {
  final double init = 0.0;
}

class InProgress extends UploadState {
  final StorageTaskEvent event1;
  final StorageTaskEvent event2;
  final StorageTaskEvent event3;
  final StorageTaskEvent event4;

  InProgress({
    @required this.event1,
    this.event2,
    this.event3,
    this.event4,
  });

  @override
  List<Object> get props => [event1];

  double progressPct() {
    return event1.snapshot.bytesTransferred / event1.snapshot.totalByteCount;
  }

  // progressState() {
  //   switch (events.type.index) {
  //     case 0:
  //       return 'resumed';
  //       break;
  //     case 1:
  //       return 'inProgress';
  //       break;
  //     case 2:
  //       return 'paused';
  //       break;
  //     case 3:
  //       return 'success';
  //       break;
  //     case 4:
  //       return 'failed';
  //       break;
  //     default:
  //       return 'Null';
  //       break;
  //   }
  // }
}

class ProcessNameUsedState extends UploadState {
  final String processName;

  ProcessNameUsedState({@required this.processName});
}

class Completed extends UploadState {}
