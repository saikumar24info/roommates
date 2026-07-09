import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/screens/details/bloc/details_bloc.dart';
import 'package:room_mates/screens/details/bloc/details_event.dart';
import 'package:room_mates/screens/details/bloc/details_state.dart';
import 'package:room_mates/screens/details/modal/user_details_modal.dart';
import 'package:room_mates/screens/landing/landing.dart';

import '../../global.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';
import '../../utils/text_utility.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/textinput.dart';

class Details extends StatefulWidget {
  final bool isFromLogin;
  const Details({super.key, required this.isFromLogin});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController(text: 'Sai Kumar');
  final _phoneNumber = TextEditingController(text: '8074450001');
  final _hostelName = TextEditingController(text: 'Manikanta Boys Hostel');
  final _roomNumber = TextEditingController(text: '302');
  final _joiningDate = TextEditingController(text: '29 Jan, 2024');
  final _roomType = TextEditingController(text: '3 Share');
  final _amount = TextEditingController(text: '6000');
  final _hostelAddress = TextEditingController(
      text: 'LIG: 333, RoadNo: 3, KPHB colony, Kukatpally');

  late final DetailsBloc detailsBloc;
  @override
  void initState() {
    detailsBloc = BlocProvider.of<DetailsBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: widget.isFromLogin ? true : false,
        backgroundColor: AppColors.primary,
        leading: widget.isFromLogin
            ? Container()
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  size: height(context) * 30,
                ),
              ),
        title: TextUtility.headerText(
            context, Strings.accountDetails, AppColors.white),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<DetailsBloc, DetailsState>(
          listener: (context, state) {
            if (state is RegisterUserLoadingState) {
              utils.show(context);
            }
            if (state is RegisterUserLoadedState) {
              utils.dismiss(context);
              if (state.isUserRegistered == true) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Landing()),
                    (route) => false);
              } else {}
            }
            if (state is RegisterUserErrorState) {
              utils.dismiss(context);
            }
          },
          builder: (context, state) {
            return detailsView();
          },
        ),
      ),
    );
  }

  Widget detailsView() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width(context) * 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height(context) * 30,
                    ),
                    Image.asset(
                      Constants.logo,
                      height: height(context) * 85,
                      width: width(context) * 85,
                    ),
                    SizedBox(
                      height: height(context) * 20,
                    ),
                    TextInput(
                      hintText: Strings.enterYourFullName,
                      textInputType: TextInputType.name,
                      controller: _fullName,
                      preficIcon: Icon(
                        Icons.home,
                        size: height(context) * 26,
                      ),
                    ),
                    SizedBox(
                      height: height(context) * 20,
                    ),
                    TextInput(
                      hintText: Strings.enterYourPhoneNumber,
                      textInputType: TextInputType.number,
                      controller: _phoneNumber,
                      preficIcon: Icon(
                        Icons.home,
                        size: height(context) * 26,
                      ),
                    ),
                    SizedBox(height: height(context) * 20),
                    TextInput(
                      hintText: Strings.enterYourHostelName,
                      textInputType: TextInputType.text,
                      controller: _hostelName,
                      preficIcon: Icon(
                        Icons.lock,
                        size: height(context) * 26,
                      ),
                    ),
                    SizedBox(height: height(context) * 20),
                    TextInput(
                      hintText: Strings.enterYourRoomNumber,
                      textInputType: TextInputType.text,
                      controller: _roomNumber,
                      preficIcon: Icon(
                        Icons.lock,
                        size: height(context) * 26,
                      ),
                    ),
                    SizedBox(height: height(context) * 20),
                    TextInput(
                      hintText: Strings.enterYourJoiningDate,
                      textInputType: TextInputType.text,
                      controller: _joiningDate,
                      preficIcon: Icon(
                        Icons.lock,
                        size: height(context) * 26,
                      ),
                    ),
                    SizedBox(height: height(context) * 20),
                    TextInput(
                      hintText: Strings.enterYourRoomType,
                      textInputType: TextInputType.text,
                      controller: _roomType,
                      preficIcon: Icon(
                        Icons.lock,
                        size: height(context) * 26,
                      ),
                    ),
                    SizedBox(height: height(context) * 20),
                    TextInput(
                      hintText: Strings.enterAmount,
                      textInputType: TextInputType.text,
                      controller: _amount,
                      preficIcon: Icon(
                        Icons.lock,
                        size: height(context) * 26,
                      ),
                    ),
                    SizedBox(height: height(context) * 20),
                    TextInput(
                      hintText: Strings.enterYourHostelName,
                      textInputType: TextInputType.text,
                      controller: _hostelAddress,
                      preficIcon: Icon(
                        Icons.lock,
                        size: height(context) * 26,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height(context) * 35),
                      child: elevatedButton(context,
                          buttonHeight: height(context) * 55,
                          buttonWidth: width(context) * 220, onPress: () async {
                        final userDetailsModal = UserDetailsModal(
                          fullName: _fullName.text,
                          phoneNumber: _phoneNumber.text,
                          hostelName: _hostelName.text,
                          roomNumber: int.parse(_roomNumber.text),
                          joiningDate: _joiningDate.text,
                          roomType: _roomType.text,
                          amount: double.parse(_amount.text),
                          hostelAddress: _hostelAddress.text,
                        );
                        detailsBloc.add(RegisterUserEvent(
                            userDetailsModal: userDetailsModal));
                      },
                          buttonText: Strings.register,
                          fontSize: fontSize(context) * 18),
                    ),
                    SizedBox(
                      height: height(context) * 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
