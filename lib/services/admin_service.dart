import '../config/supabase_config.dart';
import '../models/admin.dart';

class AdminService {
  static final _client = SupabaseConfig.client;

  // Login admin
  static Future<Map<String, dynamic>> loginAdmin({
    required String username,
    required String password,
  }) async {
    try {
      print('🔐 Mencoba login admin: $username');

      final response = await _client
          .from('admins')
          .select('*')
          .eq('username', username)
          .eq('password', password)
          .limit(1);

      if (response.isEmpty) {
        return {'success': false, 'message': 'Username atau password salah'};
      }

      final adminData = response.first;
      final admin = Admin.fromJson(adminData);

      print('✅ Login admin berhasil: ${admin.name}');
      return {
        'success': true,
        'message': 'Login berhasil',
        'admin': admin.toJsonSafe(),
      };
    } catch (e) {
      print('❌ Error login admin: $e');

      if (e.toString().contains('relation "admins" does not exist')) {
        return {
          'success': false,
          'message':
              'Database belum dikonfigurasi. Silakan hubungi administrator untuk setup tabel admins.',
        };
      }

      return {
        'success': false,
        'message': 'Terjadi kesalahan saat login: ${e.toString()}',
      };
    }
  }

  // Get admin by username
  static Future<Map<String, dynamic>> getAdminByUsername(
    String username,
  ) async {
    try {
      final response = await _client
          .from('admins')
          .select('*')
          .eq('username', username)
          .limit(1);

      if (response.isEmpty) {
        return {'success': false, 'message': 'Admin tidak ditemukan'};
      }

      final admin = Admin.fromJson(response.first);
      return {'success': true, 'admin': admin.toJsonSafe()};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // Get all admins
  static Future<Map<String, dynamic>> getAllAdmins() async {
    try {
      final response = await _client
          .from('admins')
          .select('*')
          .order('created_at', ascending: false);

      final admins =
          (response as List)
              .map((adminData) => Admin.fromJson(adminData).toJsonSafe())
              .toList();

      return {'success': true, 'admins': admins};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // Create default admin
  static Future<Map<String, dynamic>> createDefaultAdmin() async {
    try {
      // Check if admin already exists
      final existingAdmin = await getAdminByUsername('admin');
      if (existingAdmin['success']) {
        return {'success': true, 'message': 'Admin default sudah ada'};
      }

      // Insert new admin - let database generate the ID
      final response =
          await _client.from('admins').insert({
            'username': 'admin',
            'password': 'admin123',
            'email': 'admin@gostay.com',
            'name': 'Administrator GoStay',
            'role': 'super_admin',
          }).select();

      if (response.isNotEmpty) {
        final admin = Admin.fromJson(response.first);
        print('✅ Admin default berhasil dibuat: ${admin.name}');
        return {
          'success': true,
          'message': 'Admin default berhasil dibuat',
          'admin': admin.toJsonSafe(),
        };
      }

      return {'success': false, 'message': 'Gagal membuat admin default'};
    } catch (e) {
      print('❌ Error membuat admin default: $e');

      if (e.toString().contains('relation "admins" does not exist')) {
        print('''
🔴 PERHATIAN: Tabel admins belum ada di database.
🔧 Silakan buat tabel admins secara manual melalui Supabase Dashboard:

1. Login ke Supabase Dashboard: https://supabase.com/dashboard
2. Pilih project Anda
3. Buka SQL Editor
4. Jalankan SQL dari DATABASE_SETUP.md atau gunakan SQL berikut:

CREATE TABLE IF NOT EXISTS public.admins (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'admin',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Enable all for admins" ON public.admins USING (true) WITH CHECK (true);

INSERT INTO public.admins (username, password, email, name, role)
VALUES ('admin', 'admin123', 'admin@gostay.com', 'Administrator GoStay', 'super_admin');
''');
      }

      return {
        'success': false,
        'message': 'Error membuat admin default: ${e.toString()}',
      };
    }
  }

  // Update admin
  static Future<Map<String, dynamic>> updateAdmin({
    required String id,
    required String username,
    required String email,
    required String name,
    String? role,
  }) async {
    try {
      final response =
          await _client
              .from('admins')
              .update({
                'username': username,
                'email': email,
                'name': name,
                if (role != null) 'role': role,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', id)
              .select();

      if (response.isNotEmpty) {
        final admin = Admin.fromJson(response.first);
        return {
          'success': true,
          'message': 'Admin berhasil diupdate',
          'admin': admin.toJsonSafe(),
        };
      }

      return {'success': false, 'message': 'Admin tidak ditemukan'};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  // Change admin password
  static Future<Map<String, dynamic>> changeAdminPassword({
    required String id,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // Verify old password
      final response = await _client
          .from('admins')
          .select('*')
          .eq('id', id)
          .eq('password', oldPassword)
          .limit(1);

      if (response.isEmpty) {
        return {'success': false, 'message': 'Password lama tidak valid'};
      }

      // Update password
      await _client
          .from('admins')
          .update({
            'password': newPassword,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);

      return {'success': true, 'message': 'Password berhasil diubah'};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
