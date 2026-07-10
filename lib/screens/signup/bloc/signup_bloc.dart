import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/screens/signup/bloc/signup_event.dart';
import 'package:room_mates/screens/signup/bloc/signup_state.dart';
import 'package:room_mates/services/auth_service.dart';

import '../../../global.dart';
import '../../../utils/shared_prefs.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitialState()) {
    on<CompleteSignUpEvent>((event, emit) async {
      if (event.password != event.confirmPassword) {
        emit(const SignupErrorState(error: 'Passwords do not match'));
        return;
      }
      if (event.password.length < 6) {
        emit(const SignupErrorState(
            error: 'Password must be at least 6 characters'));
        return;
      }

      emit(SignupLoadingState());
      try {
        final user = await authService.signUpWithEmail(
          email: event.email.trim(),
          password: event.password,
          firstName: event.firstName.trim(),
          lastName: event.lastName.trim(),
        );

        await hostelService.ensureSeedData();

        final profile = await profileService.createProfile(
          userId: user.uid,
          firstName: event.firstName.trim(),
          lastName: event.lastName.trim(),
          email: event.email.trim(),
          phone: event.phone.trim(),
          jobTitle: event.jobTitle.trim(),
          hostelId: event.hostel.id,
          sharingTypeId: event.sharingType.id,
          paymentDate: event.paymentDate.trim(),
          amount: event.sharingType.amount,
          sharingLabel: event.sharingType.label,
          hostelName: event.hostel.name,
          hostelAddress: event.hostel.address,
        );

        await AppLocalPrefs.setUserDetails(
          uid: user.uid,
          displayName: profile.fullName,
          email: profile.email,
        );
        await AppLocalPrefs.setProfile(profile);

        emit(SignupLoadedState(profile: profile));
      } catch (error) {
        emit(SignupErrorState(error: AuthService.errorMessage(error)));
      }
    });
  }
}
