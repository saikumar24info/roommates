import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/screens/notification/bloc/notification_event.dart';
import 'package:room_mates/screens/notification/bloc/notification_state.dart';
import 'package:room_mates/screens/notification/modal/notification_modal.dart';

import '../../../services/notification.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationServices notificationService = NotificationServices();
  NotificationBloc() : super(NotificationInitialState()) {
    on<SendNotificationEvent>((event, emit) async {
      emit(NotificationSendLoadingState());
      try {
        NotificationModal notification = event.notificationModal;
        await notificationService.createNotification(
            notification.id,
            notification.imageUrl,
            notification.title,
            notification.time,
            notification.message);
        emit(NotificationSendLoadedState());
      } catch (error) {
        emit(NotificationSendErrorState());
      }
    });
  }
}
