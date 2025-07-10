import 'package:flutter/material.dart';
import 'config/supabase_config.dart';
import 'config/setup_db.dart'; // Add this import
import 'services/admin_service.dart';
import 'landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print('🔄 Memulai inisialisasi aplikasi GoStay...');

    // Initialize Supabase
    await SupabaseConfig.initialize();
    print('✅ Supabase berhasil diinisialisasi');

    // Pastikan kita menggunakan URL dan credentials yang benar
    print('📝 Menggunakan Supabase URL: ${SupabaseConfig.supabaseUrl}');

    try {
      // Test koneksi dengan timeout
      print('🔄 Melakukan test koneksi Supabase...');
      bool connected = await SupabaseConfig.testConnection();

      if (connected) {
        print('✅ Koneksi ke Supabase berhasil');

        // Check if database tables exist (doesn't create them)
        print('🔄 Memeriksa keberadaan tabel di database...');
        await SetupDatabase.setupAllTables();

        // Check for default admin
        print('🔄 Memeriksa keberadaan admin default...');
        await AdminService.createDefaultAdmin();
      } else {
        print('❌ Gagal terhubung ke Supabase');
      }
    } catch (connectionError) {
      print('❌ Error saat test koneksi: $connectionError');
    }

    print('🚀 Aplikasi GoStay siap dijalankan!');
  } catch (e) {
    print('❌ Error inisialisasi aplikasi: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoStay - Hotel Rekomendasi Solo',
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF29B6F6),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF29B6F6),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const LandingPage(),
    );
  }
}
