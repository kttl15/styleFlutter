import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gan2/model/data.dart';
import 'package:gan2/services/user_repo.dart';

part 'listview_event.dart';
part 'listview_state.dart';

class ListViewBloc extends Bloc<ListViewEvent, ListViewState> {
  @override
  ListViewState get initialState => ListViewInitial();

  @override
  Stream<ListViewState> mapEventToState(ListViewEvent event) async* {
    final FirebaseUser _user = await UserRepo().getUser();
    if (event is FetchData) {
      try {
        if (state is ListViewInitial) {
          final List<OutputData> data = await _fetchData(_user);
          yield ListViewLoaded(data: data);
          return;
        }
        if (state is ListViewLoaded) {
          await _fetchData(_user);
        }
      } catch (e) {
        //* print(e.toString());
        yield ListViewError(e);
      }
    } else if (event is RefreshData) {
      final List<OutputData> data = await _fetchData(_user);
      yield ListViewLoaded(data: data);
      return;
    }
  }

  Future<List<OutputData>> _fetchData(FirebaseUser user) async {
    //* processList will hold a list of all processes for the user
    List<OutputData> processList = List<OutputData>();
    await Firestore.instance
        .collection('images')
        .document(user.uid)
        .collection('process')
        .getDocuments()
        .then(
      (QuerySnapshot processes) {
        for (DocumentSnapshot process in processes.documents) {
          processList.add(
            OutputData(
              uid: process.data['uid'],
              processName: process.data['processName'],
              uploadDate: process.data['uploadDate'],
              locContent: process.data['locContent'],
              locIconContent: process.data['locIconContent'],
              locStyle: process.data['locStyle'],
              locIconStyle: process.data['locIconStyle'],
              locOutput: process.data['locOutput'],
              contentWeight: process.data['contentWeight'],
              styleWeight: process.data['styleWeight'],
              epoch: process.data['epoch'],
              unprocessedFlag: process.data['unprocessedFlag'],
              runOnUpload: process.data['runOnUpload'],
            ),
          );
        }
      },
    );
    processList.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
    return processList;
  }
}