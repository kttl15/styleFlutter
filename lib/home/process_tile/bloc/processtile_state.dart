part of 'processtile_bloc.dart';

abstract class ProcessTileState extends Equatable {
  const ProcessTileState();
  @override
  List<Object> get props => [];
}

class ProcessTileInitial extends ProcessTileState {
  @override
  List<Object> get props => [];
}

class OutputImageDownloadedState extends ProcessTileState {
  final OutputData data;

  OutputImageDownloadedState({@required this.data});
  @override
  List<Object> get props => [data];

  @override
  String toString() => 'OutputImageDownloadedState';
}

class OutputImageNotAvailableState extends ProcessTileState {
  @override
  String toString() => 'OutputImageNotAvailableState';
}
