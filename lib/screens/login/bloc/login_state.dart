import 'package:equatable/equatable.dart';
import 'package:room_mates/model/app_user.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitialState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoadedState extends LoginState {
  final AppUser user;

  const LoginLoadedState({required this.user});

  @override
  List<Object?> get props => [user];
}

class LoginErrorState extends LoginState {
  final String error;

  const LoginErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
