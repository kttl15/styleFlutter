part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RegisterEvent {
  //* notifies the bloc that user has changed email

  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends RegisterEvent {
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

class Submitted extends RegisterEvent {
  //* notifies bloc that user has submitted the form
  final String email;
  final String password;

  Submitted({
    @required this.email,
    @required this.password,
  });
  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}
