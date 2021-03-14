part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginInitiateEvent extends LoginEvent {
  final String username, password;

  LoginInitiateEvent(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class LogoutEvent extends LoginEvent {}
