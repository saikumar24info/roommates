import 'package:room_mates/model/hostel_specification.dart';
import 'package:room_mates/services/supabase_service.dart';
import 'package:room_mates/utils/constants.dart';
import 'package:room_mates/utils/specifications_description.dart';

class SpecificationService {
  static String iconAssetForKey(String key) {
    switch (key) {
      case 'wifi':
        return Constants.wifi;
      case 'ac':
        return Constants.ac;
      case 'food':
        return Constants.foodMenu;
      case 'elevator':
        return Constants.elevator;
      case 'ro_water':
        return Constants.roWater;
      case 'hot_water':
        return Constants.hotWater;
      case 'lockers':
        return Constants.locker;
      case 'cctv':
        return Constants.ccTV;
      default:
        return Constants.specifications;
    }
  }

  static String iconKeyFromAsset(String asset) {
    if (asset.contains('wifi')) return 'wifi';
    if (asset.contains('ac.png')) return 'ac';
    if (asset.contains('food')) return 'food';
    if (asset.contains('elevator')) return 'elevator';
    if (asset.contains('drop')) return 'ro_water';
    if (asset.contains('water_heater')) return 'hot_water';
    if (asset.contains('locker')) return 'lockers';
    if (asset.contains('cctv')) return 'cctv';
    return 'wifi';
  }

  static const iconKeys = [
    'wifi',
    'ac',
    'food',
    'elevator',
    'ro_water',
    'hot_water',
    'lockers',
    'cctv',
  ];

  /// Built-in fallback used when DB table is missing or empty.
  List<HostelSpecification> localDefaults({String hostelId = ''}) {
    return specifications
        .asMap()
        .entries
        .map(
          (entry) => HostelSpecification(
            id: 'local-${entry.key}',
            hostelId: hostelId,
            title: entry.value.title,
            description: entry.value.description,
            iconKey: iconKeyFromAsset(entry.value.icon),
            sortOrder: entry.key + 1,
            isEnabled: true,
          ),
        )
        .toList();
  }

  Future<List<HostelSpecification>> _queryEnabled(String hostelId) async {
    final response = await SupabaseService.client
        .from('hostel_specifications')
        .select()
        .eq('hostel_id', hostelId)
        .eq('is_enabled', true)
        .order('sort_order');
    return (response as List)
        .map((e) => HostelSpecification.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<HostelSpecification>> fetchForHostel(String hostelId) async {
    try {
      var items = await _queryEnabled(hostelId);
      if (items.isNotEmpty) return items;

      // Soft-seed empty hostel specs (SECURITY DEFINER RPC).
      try {
        await SupabaseService.client.rpc(
          'ensure_hostel_specifications',
          params: {'p_hostel_id': hostelId},
        );
        items = await _queryEnabled(hostelId);
        if (items.isNotEmpty) return items;
      } catch (_) {
        // RPC may not exist yet — fall through to local defaults.
      }
    } catch (_) {
      // Table missing / schema cache — use local defaults.
    }
    return localDefaults(hostelId: hostelId);
  }

  Future<List<HostelSpecification>> fetchAllForHostel(String hostelId) async {
    try {
      try {
        await SupabaseService.client.rpc(
          'ensure_hostel_specifications',
          params: {'p_hostel_id': hostelId},
        );
      } catch (_) {}

      final response = await SupabaseService.client
          .from('hostel_specifications')
          .select()
          .eq('hostel_id', hostelId)
          .order('sort_order');
      final items = (response as List)
          .map((e) => HostelSpecification.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      if (items.isNotEmpty) return items;
    } catch (_) {}
    return localDefaults(hostelId: hostelId);
  }

  Future<void> upsertSpecification({
    String? id,
    required String hostelId,
    required String title,
    required String description,
    required String iconKey,
    required int sortOrder,
    required bool isEnabled,
  }) async {
    final payload = {
      'hostel_id': hostelId,
      'title': title,
      'description': description,
      'icon_key': iconKey,
      'sort_order': sortOrder,
      'is_enabled': isEnabled,
    };
    if (id != null && id.isNotEmpty && !id.startsWith('local-')) {
      await SupabaseService.client
          .from('hostel_specifications')
          .update(payload)
          .eq('id', id);
    } else {
      await SupabaseService.client.from('hostel_specifications').insert(payload);
    }
  }

  Future<void> deleteSpecification(String id) async {
    if (id.startsWith('local-')) return;
    await SupabaseService.client
        .from('hostel_specifications')
        .delete()
        .eq('id', id);
  }
}
