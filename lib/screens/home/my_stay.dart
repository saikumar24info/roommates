import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:room_mates/screens/home/bloc/home_bloc.dart';
import 'package:room_mates/screens/home/bloc/home_event.dart';
import 'package:room_mates/screens/home/bloc/home_state.dart';

import '../../global.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: false,
        leading: IconButton(
          color: AppColors.white,
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, size: height(context) * 28),
        ),
        title: Text(
          Strings.myStay,
          style: TextStyle(
            fontSize: fontSize(context) * 20,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
      body: BlocConsumer<HomeBloc, HomeSates>(
        builder: (context, state) {
          if (state is MyStayDetailsLoadingState) {
            return const Center(
              child: SpinKitWave(
                color: AppColors.primary,
                type: SpinKitWaveType.start,
              ),
            );
          }
          if (state is MyStayDetailsLoadedState) {
            if (state.data.containsKey('message')) {
              return Center(
                child: Text(
                  state.data['message'].toString(),
                  style: TextStyle(fontSize: fontSize(context) * 16),
                ),
              );
            }
            return buildView(state.data);
          }
          if (state is MyStayDetailsLErrorState) {
            return Center(child: Text(state.error.toString()));
          }
          return const SizedBox.shrink();
        },
        listener: (context, state) {},
      ),
    );
  }

  Widget buildView(Map<String, dynamic> userData) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(width(context) * 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(width(context) * 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData['hostelName']?.toString() ?? '',
                style: TextStyle(
                  fontSize: fontSize(context) * 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: height(context) * 16),
              _infoRow(Icons.person_outline, 'Name', userData['fullName']),
              _infoRow(Icons.work_outline, 'Job', userData['jobTitle']),
              _infoRow(Icons.phone_outlined, 'Phone', userData['phoneNumber']),
              _infoRow(Icons.bed_outlined, 'Sharing', userData['roomType']),
              _infoRow(Icons.payments_outlined, 'Monthly Fee',
                  '₹${userData['amount']}/-'),
              _infoRow(Icons.calendar_today_outlined, 'Payment Date',
                  userData['paymentDate']),
              _infoRow(Icons.location_on_outlined, 'Address',
                  userData['hostelAddress']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.only(bottom: height(context) * 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: height(context) * 20, color: AppColors.primary),
          SizedBox(width: width(context) * 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize(context) * 12,
                    color: AppColors.bodyText,
                  ),
                ),
                Text(
                  value?.toString() ?? '-',
                  style: TextStyle(
                    fontSize: fontSize(context) * 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.headerText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
