import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/screens/home/bloc/home_event.dart';
import 'package:room_mates/screens/home/bloc/home_state.dart';
import 'package:room_mates/screens/home/repo/home_repo.dart';

class HomeBloc extends Bloc<HomeEvents, HomeSates> {
  HomeBloc() : super(HomeInitialState()) {
    HomeRepo homeRepo = HomeRepo();
    on<GetMyStayDetails>((event, emit) async {
      emit(MyStayDetailsLoadingState());
      try {
        Map<String, dynamic> data = await homeRepo.getMyStay();
        emit(MyStayDetailsLoadedState(data: data));
      } catch (err) {
        emit(MyStayDetailsLErrorState(error: err.toString()));
      }
    });
  }
}
