import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Project URL Anda dari Supabase Dashboard
  static const String supabaseUrl = 'https://cckwnkzywmqteyfpsd.supabase.co';

  // Anon Key dari Supabase Dashboard (API Keys section)
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNja3dua3p5d21xdGV5ZnBzZCIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzM2NDg5OTEyLCJleHAiOjIwNTIwNjU5MTJ9.NQH5qQlWLh8F6xQjBx2KqWYY5jR2L7B8qS4kU0wV6zA';

  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: true, // Set false untuk production
      );
      print('✅ Supabase berhasil diinisialisasi');
    } catch (e) {
      print('❌ Error inisialisasi Supabase: $e');
    }
  }

  // Getter untuk mengakses client Supabase
  static SupabaseClient get client => Supabase.instance.client;

  // Helper method untuk testing koneksi
  static Future<bool> testConnection() async {
    try {
      final response = await client.from('hotels').select('count(*)').limit(1);

      print('✅ Test koneksi berhasil: $response');
      return true;
    } catch (e) {
      print('❌ Test koneksi gagal: $e');
      return false;
    }
  }
}
