import 'dart:io';

import 'package:room_mates/model/user_profile.dart';
import 'package:room_mates/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  static const _avatarBucket = 'avatars';

  Future<UserProfile?> fetchProfile(String userId) async {
    final response = await SupabaseService.client
        .from('profiles')
        .select('*, hostels(name, address), sharing_types(label, amount)')
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserProfile.fromMap(Map<String, dynamic>.from(response));
  }

  /// Creates a resident profile only. Role/is_admin are enforced as resident
  /// by Supabase triggers — the client cannot self-promote.
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
          // Do not send role / is_admin — DB defaults + triggers force resident.
        })
        .select('*, hostels(name, address), sharing_types(label, amount)')
        .single();

    return UserProfile.fromMap(Map<String, dynamic>.from(response));
  }

  Future<String> uploadAvatar({
    required String userId,
    required File file,
  }) async {
    final ext = file.path.split('.').last.toLowerCase();
    final safeExt =
        (ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'webp')
            ? ext
            : 'jpg';
    final path = '$userId/avatar.$safeExt';
    final bytes = await file.readAsBytes();
    final contentType = switch (safeExt) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };

    await SupabaseService.client.storage.from(_avatarBucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: contentType,
          ),
        );

    final publicUrl =
        SupabaseService.client.storage.from(_avatarBucket).getPublicUrl(path);

    final avatarUrl = '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
    await _setAvatarUrl(userId, avatarUrl);
    return avatarUrl;
  }

  Future<void> removeAvatar(String userId) async {
    try {
      await SupabaseService.client.storage.from(_avatarBucket).remove([
        '$userId/avatar.jpg',
        '$userId/avatar.jpeg',
        '$userId/avatar.png',
        '$userId/avatar.webp',
      ]);
    } catch (_) {
      // Ignore missing files
    }
    await _setAvatarUrl(userId, null);
  }

  Future<UserProfile> updateOwnProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String jobTitle,
  }) async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Please sign in again.');
    }

    final payload = {
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'phone': phone.trim(),
      'job_title': jobTitle.trim().isEmpty ? null : jobTitle.trim(),
    };

    try {
      await SupabaseService.client.rpc(
        'update_own_profile',
        params: {
          'p_first_name': payload['first_name'],
          'p_last_name': payload['last_name'],
          'p_phone': payload['phone'],
          'p_job_title': payload['job_title'] ?? '',
        },
      );
    } catch (_) {
      // Fallback when RPC is not yet deployed.
      await SupabaseService.client
          .from('profiles')
          .update(payload)
          .eq('id', userId);
    }

    final profile = await fetchProfile(userId);
    if (profile == null) {
      throw Exception('Profile not found after update.');
    }
    return profile;
  }

  Future<void> _setAvatarUrl(String userId, String? avatarUrl) async {
    try {
      await SupabaseService.client.rpc(
        'update_own_avatar',
        params: {'p_avatar_url': avatarUrl},
      );
    } catch (_) {
      await SupabaseService.client
          .from('profiles')
          .update({'avatar_url': avatarUrl}).eq('id', userId);
    }
  }
}
