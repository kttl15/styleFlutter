import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/register/bloc/register_bloc.dart';
import 'package:gan2/services/user_repo.dart';
import 'register_form.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepo _userRepo;

  const RegisterScreen({Key key, @required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(_userRepo),
          child: RegisterForm(),
        ),
      ),
    );
  }
}
