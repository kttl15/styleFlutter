import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gan2/auth/bloc/authentication_bloc.dart';
import 'package:gan2/bloc_delegate.dart';
import 'package:gan2/home/home_screen.dart';
import 'package:gan2/login/login_screen.dart';
import 'package:gan2/services/user_repo.dart';
import 'package:gan2/splash_screen.dart';
import 'package:gan2/theme.dart';

void main() {
  //* needed if code is executed before runApp
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = MyBlocDelegate();
  final UserRepo userRepo = UserRepo();
  runApp(BlocProvider(
    create: (context) =>
        AuthenticationBloc(userRepo: userRepo)..add(AppStarted()),
    child: App(userRepo: userRepo),
  ));
}

class App extends StatelessWidget {
  final UserRepo _userRepo;

  const App({Key key, @required UserRepo userRepo})
      : assert(userRepo != null),
        _userRepo = userRepo,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme().themeData(),
      //* use BlocBuilder to render UI based on AuthenticationBloc
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialised) {
            return SplashScreen();
          } else if (state is Unauthenticated) {
            return LoginScreen(
              userRepo: _userRepo,
            );
          } else if (state is Authenticated) {
            return HomeScreen(
              user: state.user,
            );
          } else {
            return Container(
              child: Text('NULL'),
            );
          }
        },
      ),
    );
  }
}
