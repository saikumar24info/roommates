import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/screens/login/bloc/login_event.dart';
import 'package:room_mates/screens/login/bloc/login_state.dart';
import 'package:room_mates/services/auth_service.dart';

import '../../../global.dart';
import '../../../utils/shared_prefs.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginWithEmailEvent>((event, emit) async {
      emit(LoginLoadingState());
      try {
        final user = await authService.signInWithEmail(
          event.email,
          event.password,
        );

        final profile = await profileService.fetchProfile(user.uid);
        if (profile == null) {
          emit(const LoginErrorState(
              error: 'Profile not found. Please complete signup.'));
          return;
        }

        await AppLocalPrefs.setUserDetails(
          uid: user.uid,
          displayName: profile.fullName,
          email: profile.email,
          photoURL: user.photoURL,
        );
        await AppLocalPrefs.setProfile(profile);

        emit(LoginLoadedState(user: user));
      } catch (error) {
        emit(LoginErrorState(error: AuthService.errorMessage(error)));
      }
    });
  }
}
