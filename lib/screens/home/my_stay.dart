import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:room_mates/screens/home/bloc/home_bloc.dart';
import 'package:room_mates/screens/home/bloc/home_event.dart';
import 'package:room_mates/screens/home/bloc/home_state.dart';

import '../../global.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';
import '../../utils/text_utility.dart';

class MyStay extends StatefulWidget {
  const MyStay({super.key});

  @override
  State<MyStay> createState() => _MyStayState();
}

class _MyStayState extends State<MyStay> {
  late final HomeBloc homeBloc;
  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(GetMyStayDetails());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              size: height(context) * 30,
            )),
        title: TextUtility.headerText(context, Strings.myStay, AppColors.white),
      ),
      body: BlocConsumer<HomeBloc, HomeSates>(
          builder: (context, state) {
            if (state is MyStayDetailsLoadingState) {
              return const Center(
                child: SpinKitWave(
                    color: AppColors.primary, type: SpinKitWaveType.start),
              );
            }
            if (state is MyStayDetailsLoadedState) {
              return buildView(state.data);
                        }
            if (state is MyStayDetailsLErrorState) {
              return Center(
                child: Text(state.error.toString()),
              );
            }
            return Container();
          },
          listener: (context, state) {}),
    );
  }

  Widget buildView(Map<String, dynamic> userData) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width(context) * 5, vertical: height(context) * 10),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width(context) * 10,
                    vertical: height(context) * 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width(context) * 10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextUtility.headerText(context, 'Manikanta Boys Hostel-2',
                        AppColors.headerText),
                    SizedBox(
                      height: height(context) * 5,
                    ),
                    TextUtility.subTitleText(
                        context,
                        'Room No: ${userData['roomNumber'] ?? ''}',
                        AppColors.headerText),
                    SizedBox(
                      height: height(context) * 5,
                    ),
                    TextUtility.subTitleText(
                        context,
                        'Joining Date: ${userData['joiningDate'] ?? ''}',
                        AppColors.headerText),
                    SizedBox(
                      height: height(context) * 5,
                    ),
                    TextUtility.subTitleText(
                        context,
                        'Type: ${userData['roomType'] ?? ''}',
                        AppColors.headerText),
                    SizedBox(
                      height: height(context) * 5,
                    ),
                    TextUtility.subTitleText(
                        context,
                        'Fee: ${userData['amount'] ?? ''}/- Monthly',
                        AppColors.headerText),
                    SizedBox(
                      height: height(context) * 5,
                    ),
                    TextUtility.subTitleText(
                        context,
                        'Address: LIG: 333, RoadNo: 3, KPHB colony, Kukatpally',
                        AppColors.headerText,
                        maxLines: 3)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
