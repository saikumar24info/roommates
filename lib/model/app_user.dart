import 'package:supabase_flutter/supabase_flutter.dart';

class AppUser {
  final String uid;
  final String? displayName;
  final String? photoURL;
  final String? email;

  const AppUser({
    required this.uid,
    this.displayName,
    this.photoURL,
    this.email,
  });

  factory AppUser.fromSupabase(User user) {
    final metadata = user.userMetadata ?? {};
    return AppUser(
      uid: user.id,
      displayName: metadata['full_name'] as String? ??
          metadata['name'] as String?,
      photoURL: metadata['avatar_url'] as String? ??
          metadata['picture'] as String?,
      email: user.email,
    );
  }
}
