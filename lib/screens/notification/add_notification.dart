import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/screens/notification/bloc/notification_bloc.dart';
import 'package:room_mates/screens/notification/bloc/notification_event.dart';
import 'package:room_mates/screens/notification/bloc/notification_state.dart';
import 'package:room_mates/screens/notification/modal/notification_modal.dart';

import '../../global.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';
import '../../utils/text_utility.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/textinput.dart';

class AddNotification extends StatefulWidget {
  const AddNotification({super.key});

  @override
  State<AddNotification> createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  final _formKey = GlobalKey<FormState>();
  final _notificationId = TextEditingController();
  final _imageUrl = TextEditingController();
  final _title = TextEditingController();
  final _time = TextEditingController();
  final _message = TextEditingController();
  late final NotificationBloc notificationBloc;
  @override
  void initState() {
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    super.initState();
  }

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
            context, Strings.addNotification, AppColors.white),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationSendLoadingState) {
              utils.show(context);
            }
            if (state is NotificationSendLoadedState) {
              utils.dismiss(context);
            }
            if (state is NotificationSendErrorState) {
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
                      hintText: Strings.enterNotificationNumber,
                      textInputType: TextInputType.text,
                      controller: _notificationId,
                      preficIcon: Icon(
                        Icons.home,
                        size: height(context) * 26,
                      ),
                    ),
                    SizedBox(
                      height: height(context) * 20,
                    ),
                    TextInput(
                      hintText: Strings.enterNotificationImageUrl,
                      textInputType: TextInputType.number,
                      controller: _imageUrl,
                      preficIcon: Icon(
                        Icons.home,
                        size: height(context) * 26,
                      ),
                    ),
                    SizedBox(height: height(context) * 20),
                    TextInput(
                      hintText: Strings.enterNotificationTitle,
                      textInputType: TextInputType.text,
                      controller: _title,
                      preficIcon: Icon(
                        Icons.lock,
                        size: height(context) * 26,
                      ),
                    ),
                    SizedBox(height: height(context) * 20),
                    TextInput(
                      hintText: Strings.enterNotificationTime,
                      textInputType: TextInputType.text,
                      controller: _time,
                      preficIcon: Icon(
                        Icons.lock,
                        size: height(context) * 26,
                      ),
                    ),
                    SizedBox(height: height(context) * 20),
                    TextInput(
                      hintText: Strings.enterNotificationMessage,
                      textInputType: TextInputType.text,
                      controller: _message,
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
                        final notificationModal = NotificationModal(
                            id: _notificationId.text,
                            imageUrl: _imageUrl.text,
                            title: _title.text,
                            time: _time.text,
                            message: _message.text);
                        notificationBloc.add(SendNotificationEvent(
                            notificationModal: notificationModal));
                      },
                          buttonText: Strings.sendNotification,
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
