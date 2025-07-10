import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Project URL Anda dari Supabase Dashboard (dipastikan benar)
  static const String supabaseUrl = 'https://cckwvnkxzywmqteyfpsd.supabase.co';

  // Anon Key dari Supabase Dashboard (API Keys section)
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNja3d2bmt4enl3bXF0ZXlmcHNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIxMTYwNTUsImV4cCI6MjA2NzY5MjA1NX0.DrFg4NRIM8abfMEaBdnbrT1-uw75p2QoTnoXZmzOP_o';

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
      // Cek koneksi ke database dan test semua tabel penting
      final hotels = await client.from('hotels').select('count(*)').limit(1);
      print('✅ Test koneksi tabel hotels berhasil: $hotels');

      try {
        final users = await client.from('users').select('count(*)').limit(1);
        print('✅ Test koneksi tabel users berhasil: $users');
      } catch (e) {
        print('❌ Tabel users error: $e');
        print('🛠️ Membuat tabel users...');
        await createUsersTable();
      }

      try {
        final admins = await client.from('admins').select('count(*)').limit(1);
        print('✅ Test koneksi tabel admins berhasil: $admins');
      } catch (e) {
        print('❌ Tabel admins error: $e');
      }

      return true;
    } catch (e) {
      print('❌ Test koneksi gagal: $e');
      return false;
    }
  }

  // Membuat tabel users jika tidak ada
  static Future<void> createUsersTable() async {
    try {
      // SQL to create users table
      const String createTableSQL = '''
      CREATE TABLE IF NOT EXISTS public.users (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        username VARCHAR(100) NOT NULL,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
      );
      
      -- Enable RLS (Row Level Security)
      ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
      
      -- Create policy for users table
      CREATE POLICY "Enable read access for all users" ON public.users
        FOR SELECT USING (true);
      
      CREATE POLICY "Enable insert for all users" ON public.users
        FOR INSERT WITH CHECK (true);
        
      CREATE POLICY "Enable update for users" ON public.users
        FOR UPDATE USING (true);
      ''';

      // Gunakan Postgres extension untuk menjalankan SQL langsung
      await client.rpc('exec_sql', params: {'query': createTableSQL});

      print('✅ Tabel users berhasil dibuat');
    } catch (e) {
      print('❌ Error membuat tabel users: $e');
    }
  }
}
