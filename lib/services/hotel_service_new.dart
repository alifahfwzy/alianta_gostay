import '../config/supabase_config.dart';
import '../models/hotel.dart';

class HotelService {
  static final _client = SupabaseConfig.client;

  // Get all hotels
  static Future<List<Hotel>> getAllHotels() async {
    try {
      final response = await _client
          .from('hotels')
          .select()
          .order('created_at', ascending: false);

      List<Hotel> hotels = [];
      for (var item in (response as List)) {
        hotels.add(Hotel.fromJson(item));
      }
      return hotels;
    } catch (e) {
      print('❌ Error getting hotels: $e');
      return [];
    }
  }

  // Add new hotel
  static Future<Map<String, dynamic>> addHotel(Hotel hotel) async {
    try {
      print('🔄 Attempting to add hotel to database...');

      // Gunakan data yang sesuai dengan struktur database yang ada
      Map<String, dynamic> data = {
        'name': hotel.name,
        'location': hotel.location,
        'facilities': hotel.facilities,
        'image_url':
            hotel.imageUrl ??
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
        'rating': hotel.rating ?? 0.0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Tambahkan kolom tambahan jika ada di database
      if (hotel.description.isNotEmpty) {
        data['description'] = hotel.description;
      }

      print('📝 Data to be inserted: $data');

      try {
        final response =
            await _client.from('hotels').insert(data).select().single();

        print('✅ Hotel successfully added with response: $response');
        return {'success': true, 'message': 'Hotel berhasil ditambahkan'};
      } catch (e) {
        print('❌ Error during database operation: $e');
        return {
          'success': false,
          'message': 'Gagal menambahkan hotel: ${e.toString()}',
        };
      }
    } catch (e) {
      print('❌ Error adding hotel: $e');

      // More specific error handling
      String errorMessage = 'Gagal menambahkan hotel';
      if (e.toString().contains('duplicate key')) {
        errorMessage = 'Hotel dengan nama ini sudah ada';
      } else if (e.toString().contains('violates foreign key')) {
        errorMessage = 'Data referensi tidak valid';
      }

      return {'success': false, 'message': errorMessage};
    }
  }

  // Update hotel
  static Future<Map<String, dynamic>> updateHotel(
    String id,
    Hotel hotel,
  ) async {
    try {
      // Gunakan data yang sesuai dengan struktur database
      Map<String, dynamic> data = {
        'name': hotel.name,
        'location': hotel.location,
        'rating': hotel.rating ?? 0.0,
        'image_url': hotel.imageUrl,
        'facilities': hotel.facilities,
      };

      // Tambahkan kolom tambahan jika ada di database
      if (hotel.description.isNotEmpty) {
        data['description'] = hotel.description;
      }

      print('Debug - Updating hotel with data: $data');

      await _client.from('hotels').update(data).eq('id', id);

      return {'success': true, 'message': 'Hotel berhasil diupdate'};
    } catch (e) {
      print('❌ Error updating hotel: $e');
      return {
        'success': false,
        'message': 'Gagal mengupdate hotel: ${e.toString()}',
      };
    }
  }

  // Delete hotel
  static Future<Map<String, dynamic>> deleteHotel(String id) async {
    try {
      await _client.from('hotels').delete().eq('id', id);
      return {'success': true, 'message': 'Hotel berhasil dihapus'};
    } catch (e) {
      print('❌ Error deleting hotel: $e');
      return {
        'success': false,
        'message': 'Gagal menghapus hotel: ${e.toString()}',
      };
    }
  }

  // Search hotels
  static Future<List<Hotel>> searchHotels(String query) async {
    try {
      final response = await _client
          .from('hotels')
          .select()
          .or('name.ilike.%$query%,location.ilike.%$query%');

      List<Hotel> hotels = [];
      for (var item in (response as List)) {
        hotels.add(Hotel.fromJson(item));
      }
      return hotels;
    } catch (e) {
      print('❌ Error searching hotels: $e');
      return [];
    }
  }
}
