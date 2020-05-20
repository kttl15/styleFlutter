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
  final StorageTaskEvent task;

  InProgress({@required this.task});

  @override
  List<Object> get props => [task];

  double progressPct() {
    return task.snapshot.bytesTransferred / task.snapshot.totalByteCount;
  }

  progressState() {
    switch (task.type.index) {
      case 0:
        return 'resumed';
        break;
      case 1:
        return 'inProgress';
        break;
      case 2:
        return 'paused';
        break;
      case 3:
        return 'success';
        break;
      case 4:
        return 'failed';
        break;
      default:
        return 'Null';
        break;
    }
  }
}

class ProcessNameUsedState extends UploadState {
  final String processName;

  ProcessNameUsedState({@required this.processName});
}

class Completed extends UploadState {}
