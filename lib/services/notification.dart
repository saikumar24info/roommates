import 'package:firebase_database/firebase_database.dart';

class NotificationServices {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> createNotification(String id, String imageUrl, String title,
      String time, String message) async {
    final notifications = {
      id: {
        "imageUrl": imageUrl,
        "title": title,
        "time": time,
        "message": message
      }
    };
    await _db
        .child('Hyderabad/KPHB/Manikanta Boys Hostel/Notifications')
        .set(notifications);
  }
}
