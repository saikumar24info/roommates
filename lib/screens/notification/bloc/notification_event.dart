import 'package:equatable/equatable.dart';
import 'package:room_mates/screens/notification/modal/notification_modal.dart';

abstract class NotificationEvent extends Equatable {}

class SendNotificationEvent extends NotificationEvent {
  final NotificationModal notificationModal;

  SendNotificationEvent({required this.notificationModal});
  @override
  List<Object?> get props => [];
}
