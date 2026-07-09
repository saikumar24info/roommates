import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class GoogleLoginEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}
