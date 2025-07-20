import 'package:flutter/material.dart';
import 'config/supabase_config.dart';
import 'config/setup_db.dart'; // Add this import
import 'services/admin_service.dart';
import 'landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('🔄 Memulai inisialisasi aplikasi GoStay...');

    // Initialize Supabase
    await SupabaseConfig.initialize();
    debugPrint('✅ Supabase berhasil diinisialisasi');

    // Pastikan kita menggunakan URL dan credentials yang benar
    debugPrint('📝 Menggunakan Supabase URL: ${SupabaseConfig.supabaseUrl}');

    try {
      // Test koneksi dengan timeout
      debugPrint('🔄 Melakukan test koneksi Supabase...');
      bool connected = await SupabaseConfig.testConnection();

      if (connected) {
        debugPrint('✅ Koneksi ke Supabase berhasil');

        // Check if database tables exist (doesn't create them)
        debugPrint('🔄 Memeriksa keberadaan tabel di database...');
        await SetupDatabase.setupAllTables();

        // Check for default admin
        debugPrint('🔄 Memeriksa keberadaan admin default...');
        await AdminService.createDefaultAdmin();
      } else {
        debugPrint('❌ Gagal terhubung ke Supabase');
      }
    } catch (connectionError) {
      debugPrint('❌ Error saat test koneksi: $connectionError');
    }

    debugPrint('🚀 Aplikasi GoStay siap dijalankan!');
  } catch (e) {
    debugPrint('❌ Error inisialisasi aplikasi: $e');
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
      showPerformanceOverlay: false, // Menghilangkan performance overlay
      checkerboardRasterCacheImages: false, // Menghilangkan checkerboard
      checkerboardOffscreenLayers: false, // Menghilangkan checkerboard layers
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
