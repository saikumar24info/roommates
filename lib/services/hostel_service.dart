import 'package:room_mates/data/hostel_menu_data.dart';
import 'package:room_mates/model/hostel.dart';
import 'package:room_mates/model/sharing_type.dart';
import 'package:room_mates/services/supabase_service.dart';
import 'package:room_mates/utils/supabase_config.dart';

class HostelService {
  Future<void> ensureSeedData() async {
    if (SupabaseService.client.auth.currentSession == null) return;

    final hostelRows = await SupabaseService.client
        .from('hostels')
        .select('id, name, city, area');
    if ((hostelRows as List).isEmpty) return;

    final menu = HostelMenuData.weeklyMenu();
    for (final hostel in hostelRows) {
      final existing = await SupabaseService.client
          .from('food_menus')
          .select('id')
          .eq('hostel_id', hostel['id'])
          .maybeSingle();
      if (existing != null) continue;

      await SupabaseService.client.from('food_menus').insert({
        'hostel_id': hostel['id'],
        'city': hostel['city'],
        'area': hostel['area'],
        'hostel_name': hostel['name'],
        'menu_data': menu,
        'updated_at': DateTime.now().toIso8601String(),
      });
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

  /// Prefers per-hostel rent amounts; keeps global sharing_types ids for FK.
  Future<List<SharingType>> fetchRentOptionsForHostel(String hostelId) async {
    final global = await fetchSharingTypes();
    try {
      final response = await SupabaseService.client
          .from('hostel_rent_plans')
          .select()
          .eq('hostel_id', hostelId)
          .order('sort_order');
      final plans = response as List;
      if (plans.isEmpty) return global;

      final byLabel = {for (final g in global) g.label: g};
      return plans.map((row) {
        final map = Map<String, dynamic>.from(row);
        final label = map['label'] as String? ?? '';
        final globalMatch = byLabel[label];
        return SharingType(
          id: globalMatch?.id ?? (global.isNotEmpty ? global.first.id : map['id'] as String),
          label: label,
          amount: (map['amount'] as num).toDouble(),
          sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    } catch (_) {
      return global;
    }
  }
}
