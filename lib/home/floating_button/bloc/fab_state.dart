part of 'fab_bloc.dart';

abstract class FabState extends Equatable {
  const FabState();
}

class FabOpened extends FabState {
  @override
  List<Object> get props => [];
}

class FabClosed extends FabState {
  @override
  List<Object> get props => [];
}
