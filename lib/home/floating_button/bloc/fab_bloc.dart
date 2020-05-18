import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'fab_event.dart';
part 'fab_state.dart';

class FabBloc extends Bloc<FabEvent, FabState> {
  @override
  FabState get initialState => null;

  @override
  Stream<FabState> mapEventToState(
    FabEvent event,
  ) async* {
    if (event is AddProcessEvent) {
      yield* _mapAddNewProcessToState();
    } else if (event is DeleteProcessEvent) {
      yield* _mapDeleteProcessToState();
    }
  }
}

Stream<FabState> _mapAddNewProcessToState() async* {
  yield FabOpened();
}

Stream<FabState> _mapDeleteProcessToState() async* {
  yield FabClosed();
}
