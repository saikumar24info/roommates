import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/screens/login/bloc/login_event.dart';
import 'package:room_mates/screens/login/bloc/login_state.dart';

import '../../../global.dart';
import '../../../utils/shared_prefs.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(GoogleLoginLoadingState()) {
    on<GoogleLoginEvent>((event, emit) async {
      emit(GoogleLoginLoadingState());
      try {
        User? user = await userGoogleSignup.signInWithGoogle();
        await AppLocalPrefs.setUserDetails(user);
        emit(GoogleLoginLoadedState(user: user));
      } catch (error) {
        emit(GoogleLoginErrorState(error: error.toString()));
      }
    });
  }
}
