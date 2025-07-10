import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class SetupDatabase {
  static final SupabaseClient _client = SupabaseConfig.client;

  /// Setup semua tabel yang diperlukan aplikasi
  static Future<void> setupAllTables() async {
    try {
      print('🔄 Memulai setup database...');

      // Setup tables
      await createUsersTable();
      await createHotelsTable();
      await createAdminsTable();

      // Setup default data
      await insertDefaultAdmin();
      await insertSampleHotels();

      print('✅ Setup database selesai!');
    } catch (e) {
      print('❌ Error setup database: $e');
    }
  }

  /// Membuat tabel users
  static Future<void> createUsersTable() async {
    try {
      // Check if table exists
      try {
        await _client.from('users').select('count(*)').limit(1);
        print('✅ Tabel users sudah ada');
        return;
      } catch (_) {
        // Table doesn't exist, create it
      }

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
      
      -- Enable RLS
      ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
      
      -- Create policies
      CREATE POLICY "Enable read access for all users" ON public.users
        FOR SELECT USING (true);
      
      CREATE POLICY "Enable insert for all users" ON public.users
        FOR INSERT WITH CHECK (true);
        
      CREATE POLICY "Enable update for users" ON public.users
        FOR UPDATE USING (true);
      ''';

      // Gunakan SQL API untuk menjalankan SQL langsung
      await _client.rpc('exec_sql', params: {'query': createTableSQL});

      print('✅ Tabel users berhasil dibuat');
    } catch (e) {
      print('❌ Error membuat tabel users: $e');
    }
  }

  /// Membuat tabel hotels
  static Future<void> createHotelsTable() async {
    try {
      // Check if table exists
      try {
        await _client.from('hotels').select('count(*)').limit(1);
        print('✅ Tabel hotels sudah ada');
        return;
      } catch (_) {
        // Table doesn't exist, create it
      }

      // SQL to create hotels table
      const String createTableSQL = '''
      CREATE TABLE IF NOT EXISTS public.hotels (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        location VARCHAR(255) NOT NULL,
        facilities TEXT[] DEFAULT '{}',
        image_url TEXT DEFAULT 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
        rating DECIMAL(2,1) DEFAULT 4.0,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
      );
      
      -- Enable RLS
      ALTER TABLE public.hotels ENABLE ROW LEVEL SECURITY;
      
      -- Create policies
      CREATE POLICY "Enable read access for all hotels" ON public.hotels
        FOR SELECT USING (true);
      
      CREATE POLICY "Enable insert for all hotels" ON public.hotels
        FOR INSERT WITH CHECK (true);
        
      CREATE POLICY "Enable update for hotels" ON public.hotels
        FOR UPDATE USING (true);
        
      CREATE POLICY "Enable delete for hotels" ON public.hotels
        FOR DELETE USING (true);
      ''';

      // Gunakan SQL API untuk menjalankan SQL langsung
      await _client.rpc('exec_sql', params: {'query': createTableSQL});

      print('✅ Tabel hotels berhasil dibuat');
    } catch (e) {
      print('❌ Error membuat tabel hotels: $e');
    }
  }

  /// Membuat tabel admins
  static Future<void> createAdminsTable() async {
    try {
      // Check if table exists
      try {
        await _client.from('admins').select('count(*)').limit(1);
        print('✅ Tabel admins sudah ada');
        return;
      } catch (_) {
        // Table doesn't exist, create it
      }

      // SQL to create admins table
      const String createTableSQL = '''
      CREATE TABLE IF NOT EXISTS public.admins (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        username VARCHAR(100) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        email VARCHAR(255),
        name VARCHAR(255),
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
      );
      
      -- Enable RLS
      ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;
      
      -- Create policies
      CREATE POLICY "Enable read access for all admins" ON public.admins
        FOR SELECT USING (true);
      
      CREATE POLICY "Enable insert for all admins" ON public.admins
        FOR INSERT WITH CHECK (true);
        
      CREATE POLICY "Enable update for admins" ON public.admins
        FOR UPDATE USING (true);
      ''';

      // Gunakan SQL API untuk menjalankan SQL langsung
      await _client.rpc('exec_sql', params: {'query': createTableSQL});

      print('✅ Tabel admins berhasil dibuat');
    } catch (e) {
      print('❌ Error membuat tabel admins: $e');
    }
  }

  /// Menambahkan admin default
  static Future<void> insertDefaultAdmin() async {
    try {
      // Cek apakah sudah ada admin
      final existingAdmin =
          await _client
              .from('admins')
              .select()
              .eq('username', 'admin gostay')
              .maybeSingle();

      if (existingAdmin != null) {
        print('✅ Admin default sudah ada');
        return;
      }

      // Insert admin default
      await _client.from('admins').insert({
        'username': 'admin gostay',
        'password': 'aliantagostay',
        'email': 'admin@gostay.com',
        'name': 'Administrator',
      });

      print('✅ Admin default berhasil ditambahkan');
    } catch (e) {
      print('❌ Error menambahkan admin default: $e');
    }
  }

  /// Menambahkan sample hotels
  static Future<void> insertSampleHotels() async {
    try {
      // Cek jumlah hotel yang ada
      final response = await _client.from('hotels').select('count()').single();

      final count = response['count'];
      if (count > 0) {
        print('✅ Sample hotels sudah ada ($count hotel)');
        return;
      }

      // Insert sample hotels
      await _client.from('hotels').insert([
        {
          'name': 'Hotel Sahid Jaya Solo',
          'location': 'Jl. Gajah Mada No.82, Solo',
          'facilities': ['Free Wi-Fi', 'Swimming Pool', 'Restaurant'],
          'image_url':
              'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
          'rating': 4.5,
        },
        {
          'name': 'The Sunan Hotel Solo',
          'location': 'Jl. Adi Sucipto No.47, Solo',
          'facilities': ['Free Wi-Fi', 'Parking', 'Gym', 'Restaurant'],
          'image_url':
              'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400',
          'rating': 4.7,
        },
        {
          'name': 'Alila Solo',
          'location': 'Jl. Slamet Riyadi No.562, Solo',
          'facilities': ['Free Wi-Fi', 'Swimming Pool', 'Parking', 'Gym'],
          'image_url':
              'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
          'rating': 4.8,
        },
        {
          'name': 'Novotel Solo',
          'location': 'Jl. Slamet Riyadi No.366, Solo',
          'facilities': [
            'Free Wi-Fi',
            'Swimming Pool',
            'Restaurant',
            'Parking',
          ],
          'image_url':
              'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=400',
          'rating': 4.6,
        },
        {
          'name': 'Lor In Hotel Solo',
          'location': 'Jl. Adi Sucipto No.47A, Solo',
          'facilities': ['Free Wi-Fi', 'Parking', 'Restaurant'],
          'image_url':
              'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=400',
          'rating': 4.4,
        },
      ]);

      print('✅ Sample hotels berhasil ditambahkan');
    } catch (e) {
      print('❌ Error menambahkan sample hotels: $e');
    }
  }
}
