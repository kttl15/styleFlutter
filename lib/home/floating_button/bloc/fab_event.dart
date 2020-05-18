part of 'fab_bloc.dart';

abstract class FabEvent extends Equatable {
  const FabEvent();

  @override
  List<Object> get props => [];
}

class AddProcessEvent extends FabEvent {
  @override
  String toString() => 'AddProcessEvent';
}

class DeleteProcessEvent extends FabEvent {
  @override
  String toString() => 'DeleteProcessEvent';
}
