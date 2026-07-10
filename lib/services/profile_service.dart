import 'package:room_mates/model/user_profile.dart';
import 'package:room_mates/services/supabase_service.dart';
import 'package:room_mates/utils/supabase_config.dart';

class ProfileService {
  Future<UserProfile?> fetchProfile(String userId) async {
    final response = await SupabaseService.client
        .from('profiles')
        .select('*, hostels(name, address), sharing_types(label, amount)')
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserProfile.fromMap(Map<String, dynamic>.from(response));
  }

  Future<UserProfile> createProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String jobTitle,
    required String hostelId,
    required String sharingTypeId,
    required String paymentDate,
    required double amount,
    required String sharingLabel,
    required String hostelName,
    required String hostelAddress,
  }) async {
    final isAdmin = email.toLowerCase() == SupabaseConfig.adminEmail.toLowerCase();

    final response = await SupabaseService.client
        .from('profiles')
        .insert({
          'id': userId,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phone,
          'job_title': jobTitle,
          'hostel_id': hostelId,
          'sharing_type_id': sharingTypeId,
          'payment_date': paymentDate,
          'amount': amount,
          'sharing_label': sharingLabel,
          'hostel_name': hostelName,
          'hostel_address': hostelAddress,
          'is_admin': isAdmin,
        })
        .select('*, hostels(name, address), sharing_types(label, amount)')
        .single();

    return UserProfile.fromMap(Map<String, dynamic>.from(response));
  }
}
