import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import '../services/admin_service.dart';

class SetupDatabase {
  static final _client = SupabaseConfig.client;

  static Future<void> setupAllTables() async {
    print('🔄 Memeriksa keberadaan tabel di database...');
    print('🔄 Memulai pemeriksaan database...');
    print(
      '📝 Catatan: Tabel HARUS dibuat secara manual di Supabase Dashboard.',
    );
    print('📘 Silakan lihat DATABASE_SETUP.md untuk instruksi lengkap.');
    print('===================================================');
    print('🔍 PEMERIKSAAN DATABASE GOSTAY');
    print('===================================================\n');

    await checkUsersTable();
    await checkHotelsTable();
    await checkAdminsTable();

    print('✅ Pemeriksaan database selesai!');

    // Test create admin default using AdminService
    await testAdminDefault();
  }

  static Future<void> checkUsersTable() async {
    try {
      await _client.from('users').select('id').limit(1);
      print('✅ Tabel users sudah ada');
    } catch (e) {
      print('❌ Tabel users tidak ditemukan: $e');
      _printUserTableSQL();
    }
  }

  static Future<void> checkHotelsTable() async {
    try {
      await _client.from('hotels').select('id').limit(1);
      print('✅ Tabel hotels sudah ada');
    } catch (e) {
      print('❌ Tabel hotels tidak ditemukan: $e');
      _printHotelTableSQL();
    }
  }

  static Future<void> checkAdminsTable() async {
    try {
      await _client.from('admins').select('id').limit(1);
      print('✅ Tabel admins sudah ada');
    } catch (e) {
      print('❌ Tabel admins tidak ditemukan: $e');
      _printAdminTableSQL();
    }
  }

  static Future<void> testAdminDefault() async {
    try {
      print('🔄 Memeriksa keberadaan admin default...');
      final result = await AdminService.createDefaultAdmin();

      if (result['success']) {
        print('✅ ${result['message']}');
      } else {
        print('❌ ${result['message']}');
      }
    } catch (e) {
      print('❌ Error membuat admin default: $e');
    }
  }

  static void _printUserTableSQL() {
    print('''
🔴 PERHATIAN: Tabel users belum ada di database.
🔧 Silakan buat tabel users secara manual melalui Supabase Dashboard menggunakan SQL yang saya berikan.
''');
  }

  static void _printHotelTableSQL() {
    print('''
🔴 PERHATIAN: Tabel hotels belum ada di database.
🔧 Silakan buat tabel hotels secara manual melalui Supabase Dashboard menggunakan SQL yang saya berikan.
''');
  }

  static void _printAdminTableSQL() {
    print('''
🔴 PERHATIAN: Tabel admins belum ada di database.
🔧 Silakan buat tabel admins secara manual melalui Supabase Dashboard menggunakan SQL yang saya berikan.
''');
  }
}
