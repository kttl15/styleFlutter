part of 'listview_bloc.dart';

abstract class ListViewState extends Equatable {
  const ListViewState();

  @override
  List<Object> get props => [];
}

class ListViewInitial extends ListViewState {}

class ListViewLoaded extends ListViewState {
  final List<OutputData> data;

  ListViewLoaded({this.data});

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'ListViewLoaded {length: ${data.length}}';
}

class ListViewError extends ListViewState {
  final error;

  ListViewError(this.error);

  @override
  String toString() => 'Error {${error.toString()}}';
}
