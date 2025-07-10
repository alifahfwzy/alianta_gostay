import '../config/supabase_config.dart';

class UserService {
  static final _client = SupabaseConfig.client;

  // Register user
  static Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Check if email already exists
      final existingUser =
          await _client.from('users').select().eq('email', email).maybeSingle();

      if (existingUser != null) {
        return {'success': false, 'message': 'Email sudah terdaftar'};
      }

      // Insert new user
      await _client.from('users').insert({
        'email': email,
        'password': password, // In production, hash this!
        'username': username,
      });

      return {'success': true, 'message': 'Registrasi berhasil'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Login user
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await _client
              .from('users')
              .select()
              .eq('email', email)
              .eq('password', password) // In production, hash and compare!
              .maybeSingle();

      if (response != null) {
        return {'success': true, 'message': 'Login berhasil', 'user': response};
      } else {
        return {'success': false, 'message': 'Email atau password salah'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
