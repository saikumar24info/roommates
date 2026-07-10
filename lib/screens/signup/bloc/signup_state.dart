import 'package:equatable/equatable.dart';
import 'package:room_mates/model/user_profile.dart';

abstract class SignupState extends Equatable {
  const SignupState();
}

class SignupInitialState extends SignupState {
  @override
  List<Object?> get props => [];
}

class SignupLoadingState extends SignupState {
  @override
  List<Object?> get props => [];
}

class SignupLoadedState extends SignupState {
  final UserProfile profile;

  const SignupLoadedState({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class SignupErrorState extends SignupState {
  final String error;

  const SignupErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
