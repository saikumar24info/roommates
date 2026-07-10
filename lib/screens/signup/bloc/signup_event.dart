import 'package:equatable/equatable.dart';
import 'package:room_mates/model/hostel.dart';
import 'package:room_mates/model/sharing_type.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class CompleteSignUpEvent extends SignupEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;
  final String jobTitle;
  final Hostel hostel;
  final SharingType sharingType;
  final String paymentDate;

  const CompleteSignUpEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
    required this.jobTitle,
    required this.hostel,
    required this.sharingType,
    required this.paymentDate,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phone,
        hostel.id,
        sharingType.id,
      ];
}
