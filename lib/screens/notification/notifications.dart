import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:room_mates/widgets/notification_card.dart';
import '../../global.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';
import '../../utils/text_utility.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final DatabaseReference _notificationsRef = FirebaseDatabase.instance
      .ref()
      .child('Hyderabad')
      .child('KPHB')
      .child('Manikanta Boys Hostel')
      .child('Notifications');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.primary,
        leading: Padding(
          padding: EdgeInsets.only(left: width(context) * 30),
          child: Image.asset(
            Constants.notification,
            color: AppColors.white,
            fit: BoxFit.contain,
          ),
        ),
        title: TextUtility.headerText(
            context, Strings.notifications, AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width(context) * 0.05,
            vertical: height(context) * 0.05),
        child: StreamBuilder(
          stream: _notificationsRef.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red)),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitWave(
                    color: AppColors.primary, type: SpinKitWaveType.start),
              );
            }

            if (snapshot.hasData) {
              var data = snapshot.data?.snapshot.value;

              if (data is List) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var notification = data[index];
                    if (notification != null &&
                        notification is Map<dynamic, dynamic>) {
                      return notificationCard(
                        context,
                        notification['imageUrl'] ?? '',
                        notification['title'] ?? '',
                        notification['time'] ?? '',
                        notification['message'] ?? '',
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              } else if (data is Map<dynamic, dynamic>) {
                List notifications = data.values.toList();
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    var notification = notifications[index];
                    return notificationCard(
                      context,
                      notification['imageUrl'] ?? '',
                      notification['title'] ?? '',
                      notification['time'] ?? '',
                      notification['message'] ?? '',
                    );
                  },
                );
              } else {
                return const Center(child: Text(Strings.noNotifications));
              }
            }

            return const Center(child: Text(Strings.noNotifications));
          },
        ),
      ),
    );
  }
}
