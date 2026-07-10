import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/screens/notification/bloc/notification_bloc.dart';
import 'package:room_mates/screens/notification/bloc/notification_event.dart';
import 'package:room_mates/screens/notification/bloc/notification_state.dart';
import 'package:room_mates/screens/notification/modal/notification_modal.dart';

import '../../global.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/section_header.dart';
import '../../widgets/textinput.dart';

class AddNotification extends StatefulWidget {
  const AddNotification({super.key});

  @override
  State<AddNotification> createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  final _title = TextEditingController();
  final _message = TextEditingController();
  final _imageUrl = TextEditingController(
    text:
        'https://www.indianhealthyrecipes.com/wp-content/uploads/2022/07/moong-dal-dosa-recipe.jpg',
  );

  late final NotificationBloc notificationBloc;

  @override
  void initState() {
    notificationBloc = BlocProvider.of<NotificationBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _message.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : AppColors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: Text(Strings.addNotification),
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationSendLoadingState) {
            utils.show(context);
          }
          if (state is NotificationSendLoadedState) {
            utils.dismiss(context);
            _showMessage('Notification sent successfully!');
            _title.clear();
            _message.clear();
          }
          if (state is NotificationSendErrorState) {
            utils.dismiss(context);
            _showMessage('Failed to send notification', isError: true);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(width(context) * 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'Broadcast Message',
                  subtitle:
                      'Send today\'s specials or announcements to your hostel residents',
                ),
                TextInput(
                  hintText: Strings.enterNotificationTitle,
                  textInputType: TextInputType.text,
                  controller: _title,
                  preficIcon:
                      Icon(Icons.title, size: height(context) * 24),
                ),
                SizedBox(height: height(context) * 14),
                TextInput(
                  hintText: Strings.enterNotificationMessage,
                  textInputType: TextInputType.multiline,
                  controller: _message,
                  preficIcon:
                      Icon(Icons.message_outlined, size: height(context) * 24),
                ),
                SizedBox(height: height(context) * 14),
                TextInput(
                  hintText: Strings.enterNotificationImageUrl,
                  textInputType: TextInputType.url,
                  controller: _imageUrl,
                  preficIcon:
                      Icon(Icons.image_outlined, size: height(context) * 24),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height(context) * 28),
                  child: elevatedButton(
                    context,
                    buttonHeight: height(context) * 54,
                    buttonWidth: double.infinity,
                    onPress: () {
                      if (_title.text.trim().isEmpty ||
                          _message.text.trim().isEmpty) {
                        _showMessage('Title and message are required',
                            isError: true);
                        return;
                      }

                      final now = DateTime.now();
                      final timeLabel =
                          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} · ${now.day}/${now.month}/${now.year}';

                      notificationBloc.add(SendNotificationEvent(
                        notificationModal: NotificationModal(
                          id: now.millisecondsSinceEpoch.toString(),
                          imageUrl: _imageUrl.text.trim(),
                          title: _title.text.trim(),
                          time: timeLabel,
                          message: _message.text.trim(),
                        ),
                      ));
                    },
                    buttonText: Strings.sendNotification,
                    fontSize: fontSize(context) * 17,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
