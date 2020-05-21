import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/auth/bloc/authentication_bloc.dart';
import 'package:gan2/home/floating_button/bloc/fab_bloc.dart';
import 'package:gan2/home/floating_button/fab_button.dart';
import 'package:gan2/home/list_view/bloc/listview_bloc.dart';
import 'package:gan2/home/list_view/list_view_builder.dart';
// import 'package:gan2/new_process/bloc/upload_bloc.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseUser user;

  const HomeScreen({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO refresh when done uploading
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home: ' + user.email,
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          )
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ListViewBloc>(
            create: (context) => ListViewBloc()..add(FetchData()),
          ),
          // BlocProvider<UploadBloc>(
          //   create: (context) => UploadBloc(),
          // ),
        ],
        child: ListViewBuilder(),
      ),
      floatingActionButton: BlocProvider(
        create: (context) => FabBloc(),
        child: FAB(user: user),
      ),
    );
  }
}
