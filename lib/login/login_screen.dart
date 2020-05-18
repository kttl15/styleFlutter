import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/login/bloc/login_bloc.dart';
import 'package:gan2/login/login_form.dart';
import 'package:gan2/services/user_repo.dart';

class LoginScreen extends StatelessWidget {
  final UserRepo _userRepo;

  const LoginScreen({Key key, @required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepo: _userRepo),
        child: LoginForm(
          userRepo: _userRepo,
        ),
      ),
    );
  }
}
