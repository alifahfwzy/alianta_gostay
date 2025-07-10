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
      print('Error getting hotels: $e');
      return [];
    }
  }

  // Add new hotel
  static Future<bool> addHotel(Hotel hotel) async {
    try {
      await _client.from('hotels').insert(hotel.toJson());
      return true;
    } catch (e) {
      print('Error adding hotel: $e');
      return false;
    }
  }

  // Update hotel
  static Future<bool> updateHotel(String id, Hotel hotel) async {
    try {
      await _client.from('hotels').update(hotel.toJson()).eq('id', id);
      return true;
    } catch (e) {
      print('Error updating hotel: $e');
      return false;
    }
  }

  // Delete hotel
  static Future<bool> deleteHotel(String id) async {
    try {
      await _client.from('hotels').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting hotel: $e');
      return false;
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
}
