part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialised extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final FirebaseUser user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];

  @override
  //* toString is overridden to make it easier to read an AuthenticationState
  //* when printing it to the console or in Transitions
  String toString() => 'Authenticated {email : ${user.email}}';
}

class Unauthenticated extends AuthenticationState {}
