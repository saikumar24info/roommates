import 'package:room_mates/data/hostel_menu_data.dart';
import 'package:room_mates/services/supabase_service.dart';
import 'package:room_mates/utils/supabase_config.dart';

class HostelManagement {
  Future<void> createHostelData() async {
    await SupabaseService.client.from('food_menus').upsert({
      'city': SupabaseConfig.city,
      'area': SupabaseConfig.area,
      'hostel_name': SupabaseConfig.defaultHostel,
      'menu_data': HostelMenuData.weeklyMenu(),
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'hostel_id');
  }

  Future<String> registerUser({
    required String name,
    required int roomNo,
    required String joiningDate,
    required String roomType,
    required double amount,
    required String hostelName,
    required String hostelAddress,
    required String phoneNumber,
  }) async {
    final userId = SupabaseService.client.auth.currentUser?.id;

    final response = await SupabaseService.client
        .from('stays')
        .insert({
          'user_id': userId,
          'full_name': name,
          'room_number': roomNo,
          'joining_date': joiningDate,
          'room_type': roomType,
          'amount': amount,
          'hostel_name': hostelName,
          'hostel_address': hostelAddress,
          'phone_number': phoneNumber,
        })
        .select('id')
        .single();

    return response['id'] as String;
  }
}
