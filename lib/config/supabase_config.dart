import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://maqpkpsaidifvxukfafk.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hcXBrcHNhaWRpZnZ4dWtmYWZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIxNDEyMDUsImV4cCI6MjA2NzcxNzIwNX0.KtOY7dSYYGjsQRY8uxe6vuTHj5_S_uHPTDngUO77a4g';

  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: true,
      );
      print('✅ Supabase berhasil diinisialisasi');
      print('📝 URL: $supabaseUrl');
    } catch (e) {
      print('❌ Error inisialisasi Supabase: $e');
      rethrow;
    }
  }

  static SupabaseClient get client => Supabase.instance.client;

  static Future<bool> testConnection() async {
    try {
      print('🔄 Testing koneksi ke Supabase...');
      // Test dengan simple query yang benar
      await client.from('users').select('id').limit(1);
      print('✅ Koneksi ke Supabase berhasil');
      return true;
    } catch (e) {
      print('❌ Koneksi gagal: $e');
      return false;
    }
  }
}
