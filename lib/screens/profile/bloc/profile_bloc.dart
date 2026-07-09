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
        await userGoogleSignup.signOutGoogle().then((value) async {
          emit(ProfileLogoutLoadedState(isLoggedOut: true));
          await AppLocalPrefs.clearUser();
        }).catchError((error) async {
          emit(ProfileLogoutLoadedState(isLoggedOut: false));
        });
      } catch (error) {
        emit(ProfileLogoutErrorState(error: error.toString()));
      }
    });
  }
}
