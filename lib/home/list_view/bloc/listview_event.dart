part of 'listview_bloc.dart';

abstract class ListViewBuilderEvent extends Equatable {
  const ListViewBuilderEvent();

  @override
  List<Object> get props => null;
}

class FetchData extends ListViewBuilderEvent {
  @override
  String toString() => 'Fetching data.';
}

class RefreshData extends ListViewBuilderEvent {
  @override
  String toString() => 'Refreshing data.';
}
