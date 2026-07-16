import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/model/hostel.dart';
import 'package:room_mates/model/sharing_type.dart';
import 'package:room_mates/screens/login/login.dart';
import 'package:room_mates/screens/navigator.dart';
import 'package:room_mates/screens/signup/bloc/signup_bloc.dart';
import 'package:room_mates/screens/signup/bloc/signup_event.dart';
import 'package:room_mates/screens/signup/bloc/signup_state.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';
import 'package:room_mates/widgets/dropdown_field.dart';
import 'package:room_mates/widgets/elevated_button.dart';
import 'package:room_mates/widgets/section_header.dart';
import 'package:room_mates/widgets/textinput.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _jobTitle = TextEditingController();
  final _paymentDate = TextEditingController();

  List<Hostel> _hostels = [];
  List<SharingType> _sharingTypes = [];
  Hostel? _selectedHostel;
  SharingType? _selectedSharing;
  bool _loadingOptions = true;

  late final SignupBloc signupBloc;

  @override
  void initState() {
    super.initState();
    signupBloc = BlocProvider.of<SignupBloc>(context);
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    try {
      final hostels = await hostelService.fetchHostels();
      if (!mounted) return;
      setState(() {
        _hostels = hostels;
        _selectedHostel = hostels.isNotEmpty ? hostels.first : null;
        _loadingOptions = false;
      });
      if (_selectedHostel != null) {
        await _loadRentPlansForHostel(_selectedHostel!);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingOptions = false);
      _showError('Could not load hostel data. Please try again.');
    }
  }

  Future<void> _loadRentPlansForHostel(Hostel hostel) async {
    try {
      final plans =
          await hostelService.fetchRentOptionsForHostel(hostel.id);
      if (!mounted) return;
      setState(() {
        _sharingTypes = plans;
        _selectedSharing = plans.isNotEmpty ? plans.first : null;
      });
    } catch (_) {
      final fallback = await hostelService.fetchSharingTypes();
      if (!mounted) return;
      setState(() {
        _sharingTypes = fallback;
        _selectedSharing = fallback.isNotEmpty ? fallback.first : null;
      });
    }
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _jobTitle.dispose();
    _paymentDate.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  void _submit() {
    if (_selectedHostel == null || _selectedSharing == null) {
      _showError('Please select hostel and sharing type');
      return;
    }

    signupBloc.add(CompleteSignUpEvent(
      firstName: _firstName.text,
      lastName: _lastName.text,
      email: _email.text,
      password: _password.text,
      confirmPassword: _confirmPassword.text,
      phone: _phone.text,
      jobTitle: _jobTitle.text,
      hostel: _selectedHostel!,
      sharingType: _selectedSharing!,
      paymentDate: _paymentDate.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupLoadingState) {
              utils.show(context);
            } else if (state is SignupLoadedState) {
              utils.dismiss(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const NavigatorScreen()),
                (route) => false,
              );
            } else if (state is SignupErrorState) {
              utils.dismiss(context);
              _showError(state.error);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const AuthHeader(
                  title: Strings.signup,
                  subtitle: 'Join your KPHB hostel community',
                  showBackButton: true,
                ),
                Expanded(
                  child: _loadingOptions
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        )
                      : SingleChildScrollView(
                          padding: EdgeInsets.all(width(context) * 18),
                          child: Column(
                            children: [
                              const SectionHeader(
                                title: 'Personal Details',
                                subtitle: 'Tell us about yourself',
                              ),
                              TextInput(
                                hintText: 'First Name',
                                textInputType: TextInputType.name,
                                controller: _firstName,
                                preficIcon: Icon(Icons.person_outline,
                                    size: height(context) * 24),
                              ),
                              SizedBox(height: height(context) * 14),
                              TextInput(
                                hintText: 'Last Name',
                                textInputType: TextInputType.name,
                                controller: _lastName,
                                preficIcon: Icon(Icons.person_outline,
                                    size: height(context) * 24),
                              ),
                              SizedBox(height: height(context) * 14),
                              TextInput(
                                hintText: Strings.enterEmail,
                                textInputType: TextInputType.emailAddress,
                                controller: _email,
                                preficIcon: Icon(Icons.email_outlined,
                                    size: height(context) * 24),
                              ),
                              SizedBox(height: height(context) * 14),
                              TextInput(
                                hintText: Strings.enterYourPhoneNumber,
                                textInputType: TextInputType.phone,
                                controller: _phone,
                                preficIcon: Icon(Icons.phone_outlined,
                                    size: height(context) * 24),
                              ),
                              SizedBox(height: height(context) * 14),
                              TextInput(
                                hintText: 'Job Title (e.g. Software Engineer)',
                                textInputType: TextInputType.text,
                                controller: _jobTitle,
                                preficIcon: Icon(Icons.work_outline,
                                    size: height(context) * 24),
                              ),
                              const SectionHeader(
                                title: 'Account Security',
                                subtitle: 'Create your login credentials',
                              ),
                              TextInput(
                                hintText: Strings.enterPassword,
                                textInputType: TextInputType.text,
                                controller: _password,
                                obsecureText: true,
                                preficIcon: Icon(Icons.lock_outline,
                                    size: height(context) * 24),
                              ),
                              SizedBox(height: height(context) * 14),
                              TextInput(
                                hintText: Strings.enterConfirmPassword,
                                textInputType: TextInputType.text,
                                controller: _confirmPassword,
                                obsecureText: true,
                                preficIcon: Icon(Icons.lock_outline,
                                    size: height(context) * 24),
                              ),
                              const SectionHeader(
                                title: 'Hostel & Stay',
                                subtitle: 'Hyderabad · KPHB area hostels',
                              ),
                              HostelDropdown(
                                value: _selectedHostel,
                                hostels: _hostels,
                                onChanged: (h) async {
                                  setState(() => _selectedHostel = h);
                                  if (h != null) {
                                    await _loadRentPlansForHostel(h);
                                  }
                                },
                              ),
                              SizedBox(height: height(context) * 16),
                              SharingDropdown(
                                value: _selectedSharing,
                                options: _sharingTypes,
                                onChanged: (s) =>
                                    setState(() => _selectedSharing = s),
                              ),
                              SizedBox(height: height(context) * 14),
                              TextInput(
                                hintText:
                                    'Payment Date (e.g. 5th of every month)',
                                textInputType: TextInputType.text,
                                controller: _paymentDate,
                                preficIcon: Icon(Icons.calendar_today_outlined,
                                    size: height(context) * 24),
                              ),
                              if (_selectedSharing != null)
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: height(context) * 12),
                                  child: Container(
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.all(width(context) * 14),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: Text(
                                      'Monthly rent: ₹${_selectedSharing!.amount.toInt()} for ${_selectedSharing!.label}',
                                      style: TextStyle(
                                        fontSize: fontSize(context) * 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: height(context) * 28,
                                  bottom: height(context) * 24,
                                ),
                                child: elevatedButton(
                                  context,
                                  buttonHeight: height(context) * 54,
                                  buttonWidth: double.infinity,
                                  onPress: _submit,
                                  buttonText: 'Create Account',
                                  fontSize: fontSize(context) * 17,
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ),
                                ),
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: "Already have an account? ",
                                      style: TextStyle(
                                        color: AppColors.bodyText,
                                        fontSize: fontSize(context) * 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Login",
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: fontSize(context) * 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
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
