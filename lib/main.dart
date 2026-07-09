import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/screens/details/bloc/details_bloc.dart';
import 'package:room_mates/screens/home/bloc/home_bloc.dart';
import 'package:room_mates/screens/login/bloc/login_bloc.dart';
import 'package:room_mates/screens/navigator.dart';
import 'package:room_mates/screens/notification/bloc/notification_bloc.dart';
import 'package:room_mates/screens/profile/bloc/profile_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (error) {
    debugPrint("error $error");
  }
  runApp(const RoomMates());
}

class RoomMates extends StatelessWidget {
  const RoomMates({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => DetailsBloc()),
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => NotificationBloc())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RoomMates',
        home: NavigatorScreen(),
      ),
    );
  }
}
