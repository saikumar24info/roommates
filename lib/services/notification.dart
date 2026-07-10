import 'package:room_mates/services/supabase_service.dart';
import 'package:room_mates/utils/shared_prefs.dart';
import 'package:room_mates/utils/supabase_config.dart';

class NotificationServices {
  Future<void> createNotification(
    String id,
    String imageUrl,
    String title,
    String time,
    String message,
  ) async {
    final hostelId = await AppLocalPrefs.getHostelId();
    final hostelName =
        await AppLocalPrefs.getHostelName() ?? SupabaseConfig.defaultHostel;

    await SupabaseService.client.from('notifications').upsert({
      'id': id,
      'hostel_id': hostelId,
      'city': SupabaseConfig.city,
      'area': SupabaseConfig.area,
      'hostel_name': hostelName,
      'image_url': imageUrl,
      'title': title,
      'time': time,
      'message': message,
    });
  }
}
