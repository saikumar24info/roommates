import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {}

class NotificationInitialState extends NotificationState {
  @override
  List<Object?> get props => [];
}

class NotificationSendLoadingState extends NotificationState {
  @override
  List<Object?> get props => [];
}

class NotificationSendLoadedState extends NotificationState {
  @override
  List<Object?> get props => [];
}

class NotificationSendErrorState extends NotificationState {
  @override
  List<Object?> get props => [];
}
