import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gan2/new_process/add_new_process.dart';

class FAB extends StatelessWidget {
  final FirebaseUser user;

  const FAB({Key key, @required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.cyan,
      splashColor: Colors.green,
      tooltip: 'Add',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddNewProcess(user: user),
          ),
        );
      },
    );
  }
}
