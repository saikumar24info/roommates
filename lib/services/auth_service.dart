import 'package:flutter/material.dart';
import 'package:room_mates/model/app_user.dart';
import 'package:room_mates/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  Future<AppUser> signInWithEmail(String email, String password) async {
    final response = await SupabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('Sign in failed');
    }

    return AppUser.fromSupabase(user);
  }

  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await SupabaseService.client.auth.signUp(
      email: email,
      password: password,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'full_name': '$firstName $lastName',
      },
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('Sign up failed');
    }

    if (response.session == null) {
      throw const AuthException(
        'Account created. Please check your email to confirm before signing in.',
      );
    }

    return AppUser.fromSupabase(user);
  }

  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
    debugPrint('User signed out');
  }

  static String errorMessage(Object error) {
    if (error is AuthException) {
      return error.message;
    }
    if (error is PostgrestException) {
      return error.message;
    }
    return 'Something went wrong. Please try again.';
  }
}
