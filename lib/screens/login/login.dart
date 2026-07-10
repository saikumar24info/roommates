import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/screens/signup/signup.dart';
import 'package:room_mates/screens/login/bloc/login_bloc.dart';
import 'package:room_mates/screens/login/bloc/login_event.dart';
import 'package:room_mates/screens/login/bloc/login_state.dart';
import 'package:room_mates/screens/navigator.dart';
import 'package:room_mates/utils/strings.dart';
import 'package:room_mates/widgets/section_header.dart';
import 'package:room_mates/widgets/textinput.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/elevated_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  late final LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginLoadingState) {
              utils.show(context);
            } else if (state is LoginLoadedState) {
              utils.dismiss(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const NavigatorScreen()),
                (route) => false,
              );
            } else if (state is LoginErrorState) {
              utils.dismiss(context);
              _showError(state.error);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const AuthHeader(
                  title: 'Welcome Back',
                  subtitle: 'Sign in to your RoomMates account',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(width(context) * 20),
                    child: Column(
                      children: [
                        Image.asset(
                          Constants.logo,
                          height: height(context) * 72,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: height(context) * 24),
                        TextInput(
                          hintText: Strings.enterEmail,
                          textInputType: TextInputType.emailAddress,
                          controller: _email,
                          preficIcon: Icon(Icons.email_outlined,
                              size: height(context) * 24),
                        ),
                        SizedBox(height: height(context) * 16),
                        TextInput(
                          hintText: Strings.enterPassword,
                          textInputType: TextInputType.text,
                          controller: _password,
                          obsecureText: true,
                          preficIcon: Icon(Icons.lock_outline,
                              size: height(context) * 24),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: height(context) * 28),
                          child: elevatedButton(
                            context,
                            buttonHeight: height(context) * 54,
                            buttonWidth: double.infinity,
                            onPress: () {
                              final email = _email.text.trim();
                              final password = _password.text;
                              if (email.isEmpty || password.isEmpty) {
                                _showError('Please enter email and password');
                                return;
                              }
                              loginBloc.add(LoginWithEmailEvent(
                                email: email,
                                password: password,
                              ));
                            },
                            buttonText: Strings.login,
                            fontSize: fontSize(context) * 17,
                          ),
                        ),
                        SizedBox(height: height(context) * 16),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Signup(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: fontSize(context) * 15),
                              children: const [
                                TextSpan(
                                  text: '${Strings.dontHaveAccount} ',
                                  style:
                                      TextStyle(color: AppColors.bodyText),
                                ),
                                TextSpan(
                                  text: Strings.signup,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
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
              ],
            );
          },
        ),
      ),
    );
  }
}
