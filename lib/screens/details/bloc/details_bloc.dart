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
        String? stayId = await detailsRepo.registerUser(
          userDetails.fullName,
          userDetails.hostelName,
          userDetails.roomNumber,
          userDetails.joiningDate,
          userDetails.roomType,
          userDetails.amount,
          userDetails.hostelAddress,
          userDetails.phoneNumber,
        );
        if (stayId != null) {
          await AppLocalPrefs.setProfileToken(stayId);
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
