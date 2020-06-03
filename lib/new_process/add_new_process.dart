import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/new_process/advanced_new_process.dart';
import 'package:gan2/new_process/basic_new_process_form.dart';
// import 'package:gan2/home/list_view/bloc/listview_bloc.dart';
import 'package:gan2/new_process/bloc/upload_bloc.dart';

class AddNewProcess extends StatefulWidget {
  const AddNewProcess({Key key, @required this.user, @required this.textScale})
      : super(key: key);

  final double textScale;
  final FirebaseUser user;

  @override
  _AddNewProcessState createState() => _AddNewProcessState();
}

class _AddNewProcessState extends State<AddNewProcess> {
  bool viewBasic = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() {
                viewBasic = !viewBasic;
              });
            },
            child: Text(
              'ToggleView',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.white),
              textScaleFactor: widget.textScale,
            ),
          )
        ],
        title: Text(
          viewBasic ? 'Basic New Process' : 'Advance New Process',
          style: Theme.of(context).textTheme.headline1,
          textScaleFactor: widget.textScale,
        ),
      ),
      body: Center(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<UploadBloc>(
              create: (context) => UploadBloc(),
            ),
            // BlocProvider<ListViewBuilderBloc>(
            //   create: (context) => ListViewBuilderBloc(user: widget.user),
            // )
          ],
          child: viewBasic
              ? BasicNewProcessForm(
                  user: widget.user,
                  textScale: widget.textScale,
                )
              : AdvanceNewProcess(
                  user: widget.user,
                  textScale: widget.textScale,
                ),
        ),
      ),
    );
  }
}
