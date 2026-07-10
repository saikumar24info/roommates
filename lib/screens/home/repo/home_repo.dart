import 'dart:async';

import 'package:room_mates/services/supabase_service.dart';
import 'package:room_mates/utils/shared_prefs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRepo {
  Future<Map<String, dynamic>> getMyStay() async {
    final userId = await AppLocalPrefs.getUserId();
    if (userId == null || userId.isEmpty) {
      return {'status': 200, 'message': 'No Data Found'};
    }

    try {
      final response = await SupabaseService.client
          .from('profiles')
          .select('*, hostels(name, address), sharing_types(label, amount)')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        return {'status': 200, 'message': 'No Data Found'};
      }

      final hostel = response['hostels'] as Map<String, dynamic>?;
      final sharing = response['sharing_types'] as Map<String, dynamic>?;

      return {
        'fullName':
            '${response['first_name'] ?? ''} ${response['last_name'] ?? ''}'.trim(),
        'hostelName': hostel?['name'] ?? response['hostel_name'],
        'hostelAddress': hostel?['address'] ?? response['hostel_address'],
        'roomType': sharing?['label'] ?? response['sharing_label'],
        'amount': sharing?['amount'] ?? response['amount'],
        'paymentDate': response['payment_date'],
        'jobTitle': response['job_title'],
        'phoneNumber': response['phone'],
        'email': response['email'],
      };
    } on PostgrestException catch (e) {
      return {'status': 500, 'error': 'Database error: ${e.message}'};
    } on TimeoutException catch (e) {
      return {'status': 408, 'error': 'Request timeout: ${e.message}'};
    } catch (e) {
      return {'status': 400, 'error': 'Unexpected error: ${e.toString()}'};
    }
  }

  Stream<Map<String, dynamic>> watchFoodMenu() async* {
    final hostelId = await AppLocalPrefs.getHostelId();

    yield* SupabaseService.client
        .from('food_menus')
        .stream(primaryKey: ['id'])
        .map((rows) {
      final match = rows.where((row) {
        if (hostelId != null && hostelId.isNotEmpty) {
          return row['hostel_id'] == hostelId;
        }
        return true;
      });

      if (match.isEmpty) return <String, dynamic>{};

      final menuData = match.first['menu_data'];
      if (menuData is Map) {
        return Map<String, dynamic>.from(menuData);
      }
      return <String, dynamic>{};
    });
  }

  Stream<List<Map<String, dynamic>>> watchNotifications() async* {
    final hostelId = await AppLocalPrefs.getHostelId();

    yield* SupabaseService.client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .map((rows) {
      final filtered = rows.where((row) {
        if (hostelId != null && hostelId.isNotEmpty) {
          return row['hostel_id'] == hostelId;
        }
        return true;
      }).toList()
        ..sort((a, b) {
          final aTime = DateTime.tryParse(a['created_at']?.toString() ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = DateTime.tryParse(b['created_at']?.toString() ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });

      return filtered
          .map((row) => {
                'imageUrl': row['image_url'],
                'title': row['title'],
                'time': row['time'],
                'message': row['message'],
              })
          .toList();
    });
  }
}
