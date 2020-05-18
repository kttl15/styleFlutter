part of 'processtile_bloc.dart';

abstract class ProcessTileEvent extends Equatable {
  const ProcessTileEvent();
  @override
  List<Object> get props => [];
}

class DownloadOutputEvent extends ProcessTileEvent {
  final OutputData data;

  DownloadOutputEvent({@required this.data});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'DownloadOutputEvent';
}

class DownloadingOutputEvent extends ProcessTileEvent {
  @override
  String toString() => 'DownloadingOutputEvent';
}
