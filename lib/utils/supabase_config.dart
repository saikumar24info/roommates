/// Supabase project credentials.
/// Prefer --dart-define for SUPABASE_URL / SUPABASE_ANON_KEY in production builds.
/// Roles (admin / super_admin) are NEVER defined in the app — only in Supabase.
class SupabaseConfig {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://lsqpdonzcilytgguynat.supabase.co',
  );

  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxzcXBkb256Y2lseXRnZ3V5bmF0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM2MDE4MDgsImV4cCI6MjA5OTE3NzgwOH0.owS7DvdIXDlhjnpyDNdh96qwYZ7J-1oNQ3pr0wwJ1SE',
  );

  static const city = 'Hyderabad';
  static const area = 'KPHB';
  static const defaultHostel = 'Manikanta Boys Hostel';
}
