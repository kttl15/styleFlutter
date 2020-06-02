import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gan2/model/data.dart';
import 'package:gan2/services/user_repo.dart';
import 'package:meta/meta.dart';

part 'listview_event.dart';
part 'listview_state.dart';

class ListViewBloc extends Bloc<ListViewEvent, ListViewState> {
  final FirebaseUser user;

  ListViewBloc({@required this.user});
  @override
  ListViewState get initialState => ListViewInitial();

  @override
  Stream<ListViewState> mapEventToState(ListViewEvent event) async* {
    if (event is FetchData) {
      try {
        if (state is ListViewInitial) {
          final List<OutputData> data = await _fetchData(user);
          yield ListViewLoaded(data: data);
          return;
        }
        if (state is ListViewLoaded) {
          await _fetchData(user);
        }
      } catch (e) {
        //* print(e.toString());
        yield ListViewError(e);
      }
    } else if (event is RefreshData) {
      final List<OutputData> data = await _fetchData(user);
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
          if (!process.data.keys.contains('deleteProcess') ||
              !process.data['deleteProcess'])
            processList.add(
              OutputData(
                uid: process.data['uid'],
                processName: process.data['processName'],
                uploadDate: process.data['uploadDate'],
                locContent: process.data['locContent'],
                locIconContent: process.data['locIconContent'],
                locStyle: process.data['locStyle'],
                locIconStyle: process.data['locIconStyle'],
                locOutputs: process.data['locOutputs'],
                contentWeight: process.data['contentWeight'],
                styleWeight: process.data['styleWeight'],
                epoch: double.parse(process.data['epoch'].toString()),
                isProcessed: process.data['isProcessed'],
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
