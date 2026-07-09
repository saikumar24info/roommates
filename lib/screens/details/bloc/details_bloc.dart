import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/screens/details/bloc/details_event.dart';
import 'package:room_mates/screens/details/bloc/details_state.dart';
import 'package:room_mates/screens/details/modal/user_details_modal.dart';
import 'package:room_mates/screens/details/repo/details_repo.dart';
import 'package:room_mates/utils/shared_prefs.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  DetailsBloc() : super(RegisterUserLoadingState()) {
    DetailsRepo detailsRepo = DetailsRepoImpl();
    on<RegisterUserEvent>((event, emit) async {
      emit(RegisterUserLoadingState());
      try {
        UserDetailsModal userDetails = event.userDetailsModal;
        DatabaseReference userRef = await detailsRepo.registerUser(
          userDetails.fullName,
          userDetails.hostelName,
          userDetails.roomNumber,
          userDetails.joiningDate,
          userDetails.roomType,
          userDetails.amount,
          userDetails.hostelAddress,
          userDetails.phoneNumber,
        );
        if (userRef.key != null) {
          await AppLocalPrefs.setProfileToken(userRef.key);
          emit(RegisterUserLoadedState(isUserRegistered: true));
        } else {
          emit(RegisterUserLoadedState(isUserRegistered: false));
        }
      } catch (error) {
        emit(RegisterUserErrorState(error: error.toString()));
      }
    });
  }
}
