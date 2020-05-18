part of 'processtile_bloc.dart';

abstract class ProcessTileEvent extends Equatable {
  const ProcessTileEvent();
}

class DownloadOutputEvent extends ProcessTileEvent {
  final OutputData data;

  DownloadOutputEvent({@required this.data});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'DownloadOutputEvent';
}
