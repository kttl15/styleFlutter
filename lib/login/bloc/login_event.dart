part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginEvent {
  //* notifies the bloc that user has changed email
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends LoginEvent {
  //* notifies bloc that user has changed password
  final String password;

  PasswordChanged({
    @required this.password,
  });

  @override
  List<Object> get props => [password];

  @override
  String toString() {
    return 'PasswordChanged { password: $password }';
  }
}

class LoginWithGooglePressed extends LoginEvent {
  //* notifies bloc that user has pressed google signin button
}

class LoginWithCredentialsPressed extends LoginEvent {
  //* notifies bloc that user has pressed regular signin button
  final String email;
  final String password;

  LoginWithCredentialsPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }
}
