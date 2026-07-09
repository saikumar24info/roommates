import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/screens/login/bloc/login_event.dart';
import 'package:room_mates/screens/login/bloc/login_state.dart';
import 'package:room_mates/screens/signup/signup.dart';
import 'package:room_mates/utils/strings.dart';
import 'package:room_mates/widgets/textinput.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/elevated_button.dart';
import 'bloc/login_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  late final LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.white,
          body: Padding(
            padding: const EdgeInsets.only(top: 160),
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is GoogleLoginLoadingState) {
                  utils.show(context);
                } else if (state is GoogleLoginLoadedState) {
                  utils.dismiss(context);
                  if (state.user?.uid != null) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                        (route) => false);
                  }
                } else if (state is GoogleLoginErrorState) {
                  utils.dismiss(context);
                }
              },
              builder: (context, state) {
                return buildLoginForm(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(context) * 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Strings.login,
                style: TextStyle(
                  fontSize: fontSize(context) * 32,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: height(context) * 30),
              Image.asset(
                Constants.logo,
                height: height(context) * 85,
                width: width(context) * 85,
                color: AppColors.primary,
              ),
              SizedBox(height: height(context) * 20),
              TextInput(
                hintText: Strings.enterEmail,
                textInputType: TextInputType.emailAddress,
                controller: _email,
                preficIcon: Icon(
                  Icons.home,
                  size: height(context) * 26,
                ),
              ),
              SizedBox(height: height(context) * 20),
              TextInput(
                hintText: Strings.enterPassword,
                textInputType: TextInputType.text,
                controller: _password,
                preficIcon: Icon(
                  Icons.lock,
                  size: height(context) * 26,
                ),
              ),
              SizedBox(height: height(context) * 20),
              Padding(
                padding: EdgeInsets.only(top: height(context) * 35),
                child: elevatedButton(
                  context,
                  buttonHeight: height(context) * 55,
                  buttonWidth: width(context) * 220,
                  onPress: () async {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const Signup()));
                  },
                  buttonText: Strings.login,
                  fontSize: fontSize(context) * 18,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height(context) * 20),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    side: BorderSide(
                        width: height(context) * 0.1, color: AppColors.primary),
                    minimumSize:
                        Size(width(context) * 400, height(context) * 56),
                    maximumSize:
                        Size(width(context) * 400, height(context) * 56),
                    backgroundColor: AppColors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(height(context) * 6),
                    ),
                  ),
                  onPressed: () async {
                    loginBloc.add(GoogleLoginEvent());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://cdn4.iconfinder.com/data/icons/logos-brands-7/512/google_logo-google_icongoogle-512.png',
                        height: height(context) * 35,
                        width: width(context) * 35,
                      ),
                      SizedBox(
                        width: width(context) * 30,
                      ),
                      Text(
                        Strings.signupWithGoogle,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: fontSize(context) * 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
