part of 'listview_bloc.dart';

abstract class ListViewEvent extends Equatable {
  const ListViewEvent();

  @override
  List<Object> get props => null;
}

class FetchData extends ListViewEvent {
  @override
  String toString() => 'Fetching data.';
}

class RefreshData extends ListViewEvent {
  @override
  String toString() => 'Refreshing data.';
}
