import 'package:room_mates/data/hostel_menu_data.dart';
import 'package:room_mates/model/hostel.dart';
import 'package:room_mates/model/user_profile.dart';
import 'package:room_mates/services/supabase_service.dart';
import 'package:room_mates/utils/app_role.dart';
import 'package:room_mates/utils/shared_prefs.dart';
import 'package:room_mates/utils/supabase_config.dart';

class AdminService {
  Future<Hostel?> fetchHostel(String hostelId) async {
    final response = await SupabaseService.client
        .from('hostels')
        .select()
        .eq('id', hostelId)
        .maybeSingle();
    if (response == null) return null;
    return Hostel.fromMap(Map<String, dynamic>.from(response));
  }

  Future<List<Hostel>> fetchAllHostels() async {
    final response =
        await SupabaseService.client.from('hostels').select().order('name');
    return (response as List)
        .map((row) => Hostel.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<Hostel> createHostel({
    required String name,
    required String address,
    String city = SupabaseConfig.city,
    String area = SupabaseConfig.area,
  }) async {
    final response = await SupabaseService.client.rpc(
      'create_hostel',
      params: {
        'p_name': name,
        'p_address': address,
        'p_city': city,
        'p_area': area,
        'p_menu_data': HostelMenuData.weeklyMenu(),
      },
    );

    return Hostel.fromMap(Map<String, dynamic>.from(response as Map));
  }

  Future<Hostel> updateHostel({
    required String hostelId,
    required String name,
    required String address,
    required String city,
    required String area,
  }) async {
    final response = await SupabaseService.client.rpc(
      'update_hostel',
      params: {
        'p_hostel_id': hostelId,
        'p_name': name,
        'p_address': address,
        'p_city': city,
        'p_area': area,
      },
    );

    return Hostel.fromMap(Map<String, dynamic>.from(response as Map));
  }

  /// Re-seed defaults for an existing hostel (menu/specs/rents/welcome notice).
  Future<void> seedHostelDefaults(String hostelId) async {
    await SupabaseService.client.rpc(
      'seed_hostel_defaults',
      params: {
        'p_hostel_id': hostelId,
        'p_menu_data': HostelMenuData.weeklyMenu(),
      },
    );
  }

  Future<void> seedDefaultSpecifications(String hostelId) async {
    try {
      await SupabaseService.client.rpc(
        'ensure_hostel_specifications',
        params: {'p_hostel_id': hostelId},
      );
    } catch (_) {
      try {
        await seedHostelDefaults(hostelId);
      } catch (_) {
        // Ignore — UI can fall back to local defaults.
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchRentPlans(String hostelId) async {
    final response = await SupabaseService.client
        .from('hostel_rent_plans')
        .select()
        .eq('hostel_id', hostelId)
        .order('sort_order');
    return (response as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<void> upsertRentPlan({
    String? id,
    required String hostelId,
    required String label,
    required double amount,
    required int sortOrder,
  }) async {
    final payload = {
      'hostel_id': hostelId,
      'label': label,
      'amount': amount,
      'sort_order': sortOrder,
    };
    if (id != null && id.isNotEmpty) {
      await SupabaseService.client
          .from('hostel_rent_plans')
          .update(payload)
          .eq('id', id);
    } else {
      await SupabaseService.client.from('hostel_rent_plans').insert(payload);
    }
  }

  Future<void> deleteRentPlan(String id) async {
    await SupabaseService.client.from('hostel_rent_plans').delete().eq('id', id);
  }

  Future<Map<String, dynamic>?> fetchFoodMenu(String hostelId) async {
    final response = await SupabaseService.client
        .from('food_menus')
        .select('menu_data')
        .eq('hostel_id', hostelId)
        .maybeSingle();
    if (response == null) return null;
    final data = response['menu_data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  Future<void> saveFoodMenu({
    required String hostelId,
    required Map<String, dynamic> menuData,
  }) async {
    final hostel = await fetchHostel(hostelId);
    if (hostel == null) throw Exception('Hostel not found');

    await SupabaseService.client.from('food_menus').upsert({
      'hostel_id': hostelId,
      'city': hostel.city,
      'area': hostel.area,
      'hostel_name': hostel.name,
      'menu_data': menuData,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'hostel_id');
  }

  Future<List<Map<String, dynamic>>> fetchNotifications(String hostelId) async {
    final response = await SupabaseService.client
        .from('notifications')
        .select()
        .eq('hostel_id', hostelId)
        .order('created_at', ascending: false);
    return (response as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<void> upsertNotification({
    required String id,
    required String hostelId,
    required String title,
    required String message,
    required String imageUrl,
    required String time,
  }) async {
    final hostel = await fetchHostel(hostelId);
    if (hostel == null) throw Exception('Hostel not found');

    await SupabaseService.client.from('notifications').upsert({
      'id': id,
      'hostel_id': hostelId,
      'city': hostel.city,
      'area': hostel.area,
      'hostel_name': hostel.name,
      'image_url': imageUrl,
      'title': title,
      'time': time,
      'message': message,
    });
  }

  Future<void> deleteNotification(String id) async {
    await SupabaseService.client.from('notifications').delete().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> fetchServiceRequests({
    String? hostelId,
  }) async {
    var query = SupabaseService.client.from('service_requests').select();
    if (hostelId != null && hostelId.isNotEmpty) {
      query = query.eq('hostel_id', hostelId);
    }
    final response = await query.order('created_at', ascending: false);
    return (response as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<void> updateServiceRequestStatus({
    required String requestId,
    required String status,
  }) async {
    await SupabaseService.client
        .from('service_requests')
        .update({'status': status}).eq('id', requestId);
  }

  Future<List<UserProfile>> fetchProfiles({String? hostelId}) async {
    var query = SupabaseService.client
        .from('profiles')
        .select('*, hostels(name, address), sharing_types(label, amount)');
    if (hostelId != null && hostelId.isNotEmpty) {
      query = query.eq('hostel_id', hostelId);
    }
    final response = await query.order('first_name');
    return (response as List)
        .map((e) => UserProfile.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Assigns resident/admin only via secure Supabase RPC.
  /// Super-admin promotion is done only in the Supabase SQL editor.
  Future<void> assignAdmin({
    required String userId,
    required String hostelId,
    required AppRole role,
  }) async {
    if (role.isSuperAdmin) {
      throw Exception(
        'Super admin can only be granted from the Supabase dashboard.',
      );
    }
    if (role == AppRole.admin && hostelId.isEmpty) {
      throw Exception('Assign a hostel before promoting a user to admin.');
    }

    await SupabaseService.client.rpc(
      'assign_user_role',
      params: {
        'target_user_id': userId,
        'new_role': role.dbValue,
        'target_hostel_id': hostelId.isEmpty ? null : hostelId,
      },
    );
  }

  /// Resolves which hostel an admin screen should manage.
  Future<String?> resolveManagedHostelId({
    String? selectedHostelId,
  }) async {
    final role = await AppLocalPrefs.getRole();
    if (role.isSuperAdmin) {
      return selectedHostelId ?? await AppLocalPrefs.getHostelId();
    }
    return AppLocalPrefs.getHostelId();
  }
}
