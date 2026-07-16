import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {}

class ProfileLogoutEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class ProfileUploadAvatarEvent extends ProfileEvent {
  final File file;

  ProfileUploadAvatarEvent({required this.file});

  @override
  List<Object?> get props => [file.path];
}

class ProfileRemoveAvatarEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}
