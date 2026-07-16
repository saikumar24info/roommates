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

    on<ProfileUploadAvatarEvent>((event, emit) async {
      emit(ProfileAvatarLoadingState());
      try {
        final userId = await AppLocalPrefs.getUserId();
        if (userId == null || userId.isEmpty) {
          emit(ProfileAvatarErrorState(error: 'User not found'));
          return;
        }
        final url = await profileService.uploadAvatar(
          userId: userId,
          file: event.file,
        );
        await AppLocalPrefs.setProfileUrl(url);
        emit(ProfileAvatarLoadedState(avatarUrl: url));
      } catch (error) {
        emit(ProfileAvatarErrorState(error: error.toString()));
      }
    });

    on<ProfileRemoveAvatarEvent>((event, emit) async {
      emit(ProfileAvatarLoadingState());
      try {
        final userId = await AppLocalPrefs.getUserId();
        if (userId == null || userId.isEmpty) {
          emit(ProfileAvatarErrorState(error: 'User not found'));
          return;
        }
        await profileService.removeAvatar(userId);
        await AppLocalPrefs.clearProfileUrl();
        emit(ProfileAvatarLoadedState(avatarUrl: ''));
      } catch (error) {
        emit(ProfileAvatarErrorState(error: error.toString()));
      }
    });
  }
}
