import 'package:flutter/material.dart';
import 'package:gan2/register/register_screen.dart';
import 'package:gan2/services/user_repo.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepo _userRepo;

  CreateAccountButton({Key key, @required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text('Create an Account'),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return RegisterScreen(userRepo: _userRepo);
            },
          ),
        );
      },
    );
  }
}
