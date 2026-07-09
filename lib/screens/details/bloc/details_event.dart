import 'package:equatable/equatable.dart';
import 'package:room_mates/screens/details/modal/user_details_modal.dart';

abstract class DetailsEvent extends Equatable {}

class RegisterUserEvent extends DetailsEvent {
  final UserDetailsModal userDetailsModal;

  RegisterUserEvent({required this.userDetailsModal});
  @override
  List<Object?> get props => [];
}
