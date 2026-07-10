import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:room_mates/widgets/notification_card.dart';

import '../../global.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';
import '../../utils/text_utility.dart';
import '../home/repo/home_repo.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final HomeRepo _homeRepo = HomeRepo();

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
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _homeRepo.watchNotifications(),
          builder: (context, snapshot) {
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

            final notifications = snapshot.data ?? [];
            if (notifications.isEmpty) {
              return const Center(child: Text(Strings.noNotifications));
            }

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return notificationCard(
                  context,
                  notification['imageUrl'] ?? '',
                  notification['title'] ?? '',
                  notification['time'] ?? '',
                  notification['message'] ?? '',
                );
              },
            );
          },
        ),
      ),
    );
  }
}
