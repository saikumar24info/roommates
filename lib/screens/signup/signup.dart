import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../global.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';
import '../../utils/text_utility.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/textinput.dart';
import '../details/bloc/details_bloc.dart';
import '../details/bloc/details_event.dart';
import '../details/bloc/details_state.dart';
import '../details/modal/user_details_modal.dart';
import '../landing/landing.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late final DetailsBloc detailsBloc;
  @override
  void initState() {
    detailsBloc = BlocProvider.of<DetailsBloc>(context);
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _phoneNumber = TextEditingController(text: '');
  final _fullName = TextEditingController(text: '');
  final _hostelName = TextEditingController(text: 'Manikanta Boys Hostel');
  final _roomNumber = TextEditingController(text: '');
  final _joiningDate = TextEditingController(text: '');
  final _roomType = TextEditingController(text: '');
  final _amount = TextEditingController(text: '');
  final _hostelAddress = TextEditingController(
      text: 'LIG: 333, RoadNo: 3, KPHB colony, Kukatpally');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: false,
        leading: IconButton(
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
            return buildView(context);
          },
        ),
      ),
    );
  }

  Widget buildView(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: width(context) * 15),
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
                      // SizedBox(height: height(context) * 20),
                      // TextInput(
                      //   hintText: Strings.enterYourEmailId,
                      //   textInputType: TextInputType.text,
                      //   controller: _email,
                      //   preficIcon: Icon(
                      //     Icons.lock,
                      //     size: height(context) * 26,
                      //   ),
                      // ),
                      SizedBox(height: height(context) * 20),
                      TextInput(
                        hintText: Strings.enterYourPhoneNumber,
                        textInputType: TextInputType.number,
                        controller: _phoneNumber,
                        preficIcon: Icon(
                          Icons.lock,
                          size: height(context) * 26,
                        ),
                      ),
                      SizedBox(height: height(context) * 20),
                      TextInput(
                        hintText: Strings.hostelName,
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
                        textInputType: TextInputType.number,
                        controller: _roomNumber,
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
                        hintText: Strings.enterYourJoiningDate,
                        textInputType: TextInputType.datetime,
                        controller: _joiningDate,
                        preficIcon: Icon(
                          Icons.lock,
                          size: height(context) * 26,
                        ),
                      ),
                      SizedBox(height: height(context) * 20),
                      TextInput(
                        hintText: Strings.enterAmount,
                        textInputType: TextInputType.number,
                        controller: _amount,
                        preficIcon: Icon(
                          Icons.lock,
                          size: height(context) * 26,
                        ),
                      ),
                      SizedBox(height: height(context) * 20),
                      TextInput(
                        hintText: Strings.enterYourHostelAddress,
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
                            buttonWidth: width(context) * 220, onPress: () {
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
                      SizedBox(height: height(context) * 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
