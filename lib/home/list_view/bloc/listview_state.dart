part of 'listview_bloc.dart';

abstract class ListViewBuilderState extends Equatable {
  const ListViewBuilderState();

  @override
  List<Object> get props => [];
}

class ListViewBuilderInitial extends ListViewBuilderState {}

class ListViewBuilderLoaded extends ListViewBuilderState {
  final List<OutputData> data;

  ListViewBuilderLoaded({this.data});

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'ListViewBuilderLoaded {length: ${data.length}}';
}

class ListViewBuilderError extends ListViewBuilderState {
  final error;

  ListViewBuilderError(this.error);

  @override
  String toString() => 'ListViewBuilderError: {${error.toString()}}';
}
