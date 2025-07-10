import '../config/supabase_config.dart';
import '../models/user.dart';

class UserService {
  static final _client = SupabaseConfig.client;

  // Register user
  static Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      print('📝 Mencoba mendaftarkan user: $email');

      // Insert new user directly - mencoba langsung insert
      try {
        // Check if user already exists
        print('🔍 Memeriksa apakah email sudah terdaftar: $email');
        final existingUserResponse =
            await _client
                .from('users')
                .select('email')
                .eq('email', email)
                .maybeSingle();

        print('📋 Hasil pencarian user: $existingUserResponse');

        if (existingUserResponse != null) {
          print('❌ Email sudah terdaftar: $email');
          return {'success': false, 'message': 'Email sudah terdaftar'};
        }

        // Create User object and insert
        final newUser = User(
          email: email,
          password: password, // In production, hash this!
          username: username,
        );

        print('➕ Menambahkan user baru: $email');
        await _client.from('users').insert(newUser.toJson());

        print('✅ Registrasi berhasil: $email');
        return {'success': true, 'message': 'Registrasi berhasil'};
      } catch (e) {
        print('❌ Error registrasi: $e');

        if (e.toString().contains('does not exist') ||
            e.toString().contains('not found') ||
            e.toString().contains('relation') ||
            e.toString().contains('table')) {
          print('� PERHATIAN: Tabel users belum ada di database!');
          print('''
⚠️ Tabel users belum dibuat di Supabase Dashboard.
📘 Silakan ikuti instruksi di DATABASE_SETUP.md untuk membuat tabel users.

Langkah singkat:
1. Login ke Supabase Dashboard: https://supabase.com/dashboard
2. Pilih project Anda
3. Buka SQL Editor
4. Jalankan SQL dari DATABASE_SETUP.md untuk membuat tabel users
''');

          return {
            'success': false,
            'message':
                'Database belum dikonfigurasi. Silakan hubungi administrator untuk setup tabel users.',
          };
        }

        // Handle other registration errors
        String errorMessage = e.toString();
        if (errorMessage.contains('duplicate key') ||
            errorMessage.contains('already exists')) {
          return {
            'success': false,
            'message': 'Email sudah terdaftar. Silakan gunakan email lain.',
          };
        }

        return {
          'success': false,
          'message':
              'Gagal mendaftar: ${errorMessage.split('Exception:').last.trim()}',
        };
      }
    } catch (e) {
      print('❌ Error umum: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan sistem. Coba lagi nanti.',
      };
    }
  }

  // Login user
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      print('🔑 Mencoba login: $email');

      try {
        final response =
            await _client
                .from('users')
                .select()
                .eq('email', email)
                .eq('password', password) // In production, hash and compare!
                .maybeSingle();

        print('📋 Hasil login: $response');

        if (response != null) {
          print('✅ Login berhasil: $email');
          final user = User.fromJson(response);
          return {
            'success': true,
            'message': 'Login berhasil',
            'user': user.toJsonSafe(), // Return safe version without password
          };
        } else {
          print('❌ Email/password salah: $email');
          return {'success': false, 'message': 'Email atau password salah'};
        }
      } catch (e) {
        print('❌ Error saat login: $e');

        // Cek jika tabel tidak ditemukan
        if (e.toString().contains('does not exist') ||
            e.toString().contains('not found') ||
            e.toString().contains('relation') ||
            e.toString().contains('table')) {
          print('🔴 PERHATIAN: Tabel users belum ada di database!');
          print('''
⚠️ Tabel users belum dibuat di Supabase Dashboard.
📘 Silakan ikuti instruksi di DATABASE_SETUP.md untuk membuat tabel users.

Langkah singkat:
1. Login ke Supabase Dashboard: https://supabase.com/dashboard
2. Pilih project Anda
3. Buka SQL Editor
4. Jalankan SQL dari DATABASE_SETUP.md untuk membuat tabel users
''');

          return {
            'success': false,
            'message':
                'Database belum dikonfigurasi. Silakan hubungi administrator untuk setup tabel users.',
          };
        }

        return {
          'success': false,
          'message':
              'Gagal login: ${e.toString().split('Exception:').last.trim()}',
        };
      }
    } catch (e) {
      print('❌ Error umum login: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan sistem. Coba lagi nanti.',
      };
    }
  }

  // Get user by ID
  static Future<User?> getUserById(String id) async {
    try {
      final response =
          await _client.from('users').select().eq('id', id).maybeSingle();

      if (response != null) {
        return User.fromJson(response);
      }
      return null;
    } catch (e) {
      print('❌ Error getting user by ID: $e');
      return null;
    }
  }

  // Get user by email
  static Future<User?> getUserByEmail(String email) async {
    try {
      final response =
          await _client.from('users').select().eq('email', email).maybeSingle();

      if (response != null) {
        return User.fromJson(response);
      }
      return null;
    } catch (e) {
      print('❌ Error getting user by email: $e');
      return null;
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateUser({
    required String id,
    String? username,
    String? email,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (username != null) updateData['username'] = username;
      if (email != null) updateData['email'] = email;

      if (updateData.isEmpty) {
        return {'success': false, 'message': 'Tidak ada data yang diupdate'};
      }

      await _client.from('users').update(updateData).eq('id', id);

      return {'success': true, 'message': 'Profil berhasil diupdate'};
    } catch (e) {
      print('❌ Error updating user: $e');
      return {
        'success': false,
        'message': 'Gagal mengupdate profil: ${e.toString()}',
      };
    }
  }

  // Change password
  static Future<Map<String, dynamic>> changePassword({
    required String id,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // Verify old password first
      final user = await getUserById(id);
      if (user == null) {
        return {'success': false, 'message': 'User tidak ditemukan'};
      }

      if (user.password != oldPassword) {
        return {'success': false, 'message': 'Password lama tidak sesuai'};
      }

      // Update password
      await _client
          .from('users')
          .update({'password': newPassword}) // In production, hash this!
          .eq('id', id);

      return {'success': true, 'message': 'Password berhasil diubah'};
    } catch (e) {
      print('❌ Error changing password: $e');
      return {
        'success': false,
        'message': 'Gagal mengubah password: ${e.toString()}',
      };
    }
  }
}
