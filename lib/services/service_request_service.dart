import 'package:room_mates/model/service_request.dart';
import 'package:room_mates/services/supabase_service.dart';
import 'package:room_mates/utils/shared_prefs.dart';

class ServiceRequestService {
  Future<List<ServiceRequest>> fetchMyRequests() async {
    final userId = await AppLocalPrefs.getUserId();
    if (userId == null || userId.isEmpty) return [];

    final response = await SupabaseService.client
        .from('service_requests')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((row) => ServiceRequest.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<ServiceRequest> createRequest({
    required String category,
    required String title,
    required String description,
  }) async {
    final userId = await AppLocalPrefs.getUserId();
    final hostelId = await AppLocalPrefs.getHostelId();
    if (userId == null || userId.isEmpty) {
      throw Exception('Please sign in again to submit a request.');
    }

    final response = await SupabaseService.client
        .from('service_requests')
        .insert({
          'user_id': userId,
          'hostel_id': (hostelId != null && hostelId.isNotEmpty) ? hostelId : null,
          'category': category,
          'title': title,
          'description': description,
          'status': 'Open',
        })
        .select()
        .single();

    return ServiceRequest.fromMap(Map<String, dynamic>.from(response));
  }
}
