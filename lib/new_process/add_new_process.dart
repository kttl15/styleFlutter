import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/home/list_view/bloc/listview_bloc.dart';
import 'package:gan2/new_process/bloc/upload_bloc.dart';
import 'package:gan2/new_process/new_process_form.dart';

class AddNewProcess extends StatefulWidget {
  final FirebaseUser user;

  const AddNewProcess({Key key, @required this.user}) : super(key: key);
  @override
  _AddNewProcessState createState() => _AddNewProcessState();
}

class _AddNewProcessState extends State<AddNewProcess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add A New Process'),
      ),
      body: Center(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<UploadBloc>(
              create: (context) => UploadBloc(),
            ),
            BlocProvider<ListViewBloc>(
              create: (context) => ListViewBloc(),
            )
          ],
          child: NewProcessForm(
            user: widget.user,
          ),
        ),
      ),
    );
  }
}
