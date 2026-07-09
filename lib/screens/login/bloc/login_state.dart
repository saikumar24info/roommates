import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class GoogleLoginLoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

class GoogleLoginLoadedState extends LoginState {
  final User? user;

  const GoogleLoginLoadedState({required this.user});
  @override
  List<Object?> get props => [];
}

class GoogleLoginErrorState extends LoginState {
  final String error;

  const GoogleLoginErrorState({required this.error});
  @override
  List<Object?> get props => [];
}
