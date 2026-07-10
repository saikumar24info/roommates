import 'package:room_mates/data/hostel_menu_data.dart';
import 'package:room_mates/model/hostel.dart';
import 'package:room_mates/model/sharing_type.dart';
import 'package:room_mates/services/supabase_service.dart';
import 'package:room_mates/utils/supabase_config.dart';

class HostelService {
  Future<void> ensureSeedData() async {
    if (SupabaseService.client.auth.currentSession == null) return;

    final hostelRows =
        await SupabaseService.client.from('hostels').select('id, name, city, area');
    if ((hostelRows as List).isEmpty) return;

    final menu = HostelMenuData.weeklyMenu();
    for (final hostel in hostelRows) {
      await SupabaseService.client.from('food_menus').upsert({
        'hostel_id': hostel['id'],
        'city': hostel['city'],
        'area': hostel['area'],
        'hostel_name': hostel['name'],
        'menu_data': menu,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'hostel_id');
    }
  }

  Future<List<Hostel>> fetchHostels() async {
    final response = await SupabaseService.client
        .from('hostels')
        .select()
        .eq('city', SupabaseConfig.city)
        .eq('area', SupabaseConfig.area)
        .order('name');

    return (response as List)
        .map((row) => Hostel.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<List<SharingType>> fetchSharingTypes() async {
    final response = await SupabaseService.client
        .from('sharing_types')
        .select()
        .order('sort_order');

    return (response as List)
        .map((row) => SharingType.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }
}
