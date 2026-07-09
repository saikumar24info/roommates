import 'package:equatable/equatable.dart';

abstract class DetailsState extends Equatable {}

class RegisterUserLoadingState extends DetailsState {
  @override
  List<Object?> get props => [];
}

class RegisterUserLoadedState extends DetailsState {
  final bool? isUserRegistered;

  RegisterUserLoadedState({required this.isUserRegistered});
  @override
  List<Object?> get props => [isUserRegistered];
}

class RegisterUserErrorState extends DetailsState {
  final String error;

  RegisterUserErrorState({required this.error});
  @override
  List<Object?> get props => [];
}
