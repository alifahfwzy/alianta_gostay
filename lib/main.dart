import 'package:flutter/material.dart';
import 'config/supabase_config.dart';
import 'services/admin_service.dart';
import 'landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Supabase
    await SupabaseConfig.initialize();

    // Test koneksi (optional, bisa dihapus di production)
    await SupabaseConfig.testConnection();

    // Create default admin if not exists
    await AdminService.createDefaultAdmin();

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
