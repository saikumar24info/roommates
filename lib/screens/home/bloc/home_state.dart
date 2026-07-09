import 'package:equatable/equatable.dart';

abstract class HomeSates extends Equatable {}

class HomeInitialState extends HomeSates {
  @override
  List<Object?> get props => [];
}

class MyStayDetailsLoadingState extends HomeSates {
  @override
  List<Object?> get props => [];
}

class MyStayDetailsLoadedState extends HomeSates {
  final Map<String, dynamic> data;

  MyStayDetailsLoadedState({required this.data});
  @override
  List<Object?> get props => [];
}

class MyStayDetailsLErrorState extends HomeSates {
  final String error;

  MyStayDetailsLErrorState({required this.error});
  @override
  List<Object?> get props => [];
}
