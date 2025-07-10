import '../config/supabase_config.dart';

class AdminService {
  static final _client = SupabaseConfig.client;

  // Login admin
  static Future<Map<String, dynamic>> loginAdmin({
    required String username,
    required String password,
  }) async {
    try {
      final response =
          await _client
              .from('admins')
              .select()
              .eq('username', username)
              .eq('password', password) // In production, hash and compare!
              .maybeSingle();

      if (response != null) {
        return {
          'success': true,
          'message': 'Login admin berhasil',
          'admin': response,
        };
      } else {
        return {'success': false, 'message': 'Username atau password salah'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Get admin by id
  static Future<Map<String, dynamic>?> getAdminById(String id) async {
    try {
      final response =
          await _client.from('admins').select().eq('id', id).maybeSingle();

      return response;
    } catch (e) {
      print('Error getting admin: $e');
      return null;
    }
  }

  // Create default admin if not exists
  static Future<void> createDefaultAdmin() async {
    try {
      // Check if admin already exists
      final existingAdmin =
          await _client
              .from('admins')
              .select()
              .eq('username', 'admin gostay')
              .maybeSingle();

      if (existingAdmin == null) {
        // Create default admin
        await _client.from('admins').insert({
          'username': 'admin gostay',
          'password': 'aliantagostay', // In production, hash this!
          'email': 'admin@gostay.com',
          'name': 'Administrator GoStay',
        });
        print('✅ Default admin created successfully');
      } else {
        print('✅ Default admin already exists');
      }
    } catch (e) {
      print('❌ Error creating default admin: $e');
    }
  }
}
