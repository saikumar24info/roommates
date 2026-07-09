import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {}

class ProfileLogoutEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}
