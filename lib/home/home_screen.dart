import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/auth/bloc/authentication_bloc.dart';
import 'package:gan2/home/floating_button/bloc/fab_bloc.dart';
import 'package:gan2/home/floating_button/fab_button.dart';
import 'package:gan2/home/list_view/bloc/listview_bloc.dart';
import 'package:gan2/home/list_view/list_view_builder.dart';
// import 'package:gan2/new_process/bloc/upload_bloc.dart';

class HomeScreen extends StatefulWidget {
  final FirebaseUser user;

  const HomeScreen({Key key, this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double textScale = 0.7;

  void _changeTextScale(String val) {
    switch (val) {
      case 'smallFont':
        setState(() {
          textScale = 0.5;
        });
        break;
      case 'mediumFont':
        setState(() {
          textScale = 0.7;
        });
        break;
      case 'bigFont':
        setState(() {
          textScale = 1.0;
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Home: ' + widget.user.email,
            style: Theme.of(context).textTheme.headline1,
            textScaleFactor: textScale,
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _changeTextScale,
              itemBuilder: (context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem(
                    child: Text('Small'),
                    value: 'smallFont',
                  ),
                  PopupMenuItem(
                    child: Text('Medium'),
                    value: 'mediumFont',
                  ),
                  PopupMenuItem(
                    child: Text('Big'),
                    value: 'bigFont',
                  ),
                ];
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
            )
          ],
        ),
        body: BlocProvider<ListViewBuilderBloc>(
          create: (context) =>
              ListViewBuilderBloc(user: widget.user)..add(FetchData()),
          child: ListViewBuilder(
            textScale: textScale,
          ),
        ),
        floatingActionButton: BlocProvider(
          create: (context) => FabBloc(),
          child: FAB(
            user: widget.user,
            textScale: textScale,
          ),
        ),
      ),
    );
  }
}
