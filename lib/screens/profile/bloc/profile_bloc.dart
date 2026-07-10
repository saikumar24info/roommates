import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/screens/profile/bloc/profile_event.dart';
import 'package:room_mates/screens/profile/bloc/profile_state.dart';

import '../../../global.dart';
import '../../../utils/shared_prefs.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitialState()) {
    on<ProfileLogoutEvent>((event, emit) async {
      emit(ProfileLogoutLoadingState());
      try {
        await authService.signOut();
        await AppLocalPrefs.clearUser();
        emit(ProfileLogoutLoadedState(isLoggedOut: true));
      } catch (error) {
        emit(ProfileLogoutErrorState(error: error.toString()));
      }
    });
  }
}
