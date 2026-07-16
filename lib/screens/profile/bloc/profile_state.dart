import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {}

class ProfileInitialState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLogoutLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLogoutLoadedState extends ProfileState {
  final bool? isLoggedOut;

  ProfileLogoutLoadedState({required this.isLoggedOut});
  @override
  List<Object?> get props => [isLoggedOut];
}

class ProfileLogoutErrorState extends ProfileState {
  final String error;

  ProfileLogoutErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}

class ProfileAvatarLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileAvatarLoadedState extends ProfileState {
  final String avatarUrl;

  ProfileAvatarLoadedState({required this.avatarUrl});

  @override
  List<Object?> get props => [avatarUrl];
}

class ProfileAvatarErrorState extends ProfileState {
  final String error;

  ProfileAvatarErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
