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

      return (response as List).map((hotel) => Hotel.fromJson(hotel)).toList();
    } catch (e) {
      print('❌ Error getting hotels: $e');

      if (e.toString().contains('does not exist') ||
          e.toString().contains('not found') ||
          e.toString().contains('relation') ||
          e.toString().contains('table')) {
        print('🔴 PERHATIAN: Tabel hotels belum ada di database!');
        print('📘 Silakan lihat DATABASE_SETUP.md untuk membuat tabel hotels');
      }

      return [];
    }
  }

  // Add new hotel
  static Future<Map<String, dynamic>> addHotel(Hotel hotel) async {
    try {
      await _client.from('hotels').insert(hotel.toJson());
      return {'success': true, 'message': 'Hotel berhasil ditambahkan'};
    } catch (e) {
      print('❌ Error adding hotel: $e');

      if (e.toString().contains('does not exist') ||
          e.toString().contains('not found') ||
          e.toString().contains('relation') ||
          e.toString().contains('table')) {
        print('🔴 PERHATIAN: Tabel hotels belum ada di database!');
        print('📘 Silakan lihat DATABASE_SETUP.md untuk membuat tabel hotels');
      }

      return {
        'success': false,
        'message': 'Gagal menambahkan hotel: ${e.toString()}',
      };
    }
  }

  // Update hotel
  static Future<Map<String, dynamic>> updateHotel(
    String id,
    Hotel hotel,
  ) async {
    try {
      await _client.from('hotels').update(hotel.toJson()).eq('id', id);
      return {'success': true, 'message': 'Hotel berhasil diupdate'};
    } catch (e) {
      print('❌ Error updating hotel: $e');

      if (e.toString().contains('does not exist') ||
          e.toString().contains('not found') ||
          e.toString().contains('relation') ||
          e.toString().contains('table')) {
        print('🔴 PERHATIAN: Tabel hotels belum ada di database!');
        print('📘 Silakan lihat DATABASE_SETUP.md untuk membuat tabel hotels');
      }

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
          .or('name.ilike.%$query%,location.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List).map((hotel) => Hotel.fromJson(hotel)).toList();
    } catch (e) {
      print('Error searching hotels: $e');
      return [];
    }
  }

  // Get hotel by ID
  static Future<Hotel?> getHotelById(String id) async {
    try {
      final response =
          await _client.from('hotels').select().eq('id', id).maybeSingle();

      if (response != null) {
        return Hotel.fromJson(response);
      }
      return null;
    } catch (e) {
      print('❌ Error getting hotel by ID: $e');
      return null;
    }
  }

  // Get top rated hotels
  static Future<List<Hotel>> getTopRatedHotels({int limit = 5}) async {
    try {
      final response = await _client
          .from('hotels')
          .select()
          .order('rating', ascending: false)
          .limit(limit);

      return (response as List).map((hotel) => Hotel.fromJson(hotel)).toList();
    } catch (e) {
      print('❌ Error getting top rated hotels: $e');
      return [];
    }
  }
}
