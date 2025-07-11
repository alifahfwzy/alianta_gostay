import 'package:flutter/material.dart';
import 'models/hotel.dart';
import 'services/hotel_service.dart';

class HotelDatabase {
  static List<Hotel> _hotels = [];

  static List<Hotel> get hotels => _hotels;

  static Future<void> loadHotels() async {
    try {
      _hotels = await HotelService.getAllHotels();
      print('✅ Berhasil load ${_hotels.length} hotel dari database');
    } catch (e) {
      print('❌ Error loading hotels: $e');
      // Fallback ke data dummy jika error
      _hotels = _getDummyHotels();
    }
  }

  static List<Hotel> _getDummyHotels() {
    return [
      Hotel(
        name: 'Hotel Sahid Jaya Solo',
        location: 'Jl. Gajah Mada',
        description:
            'Hotel bintang 4 dengan lokasi strategis di pusat kota Solo',
        rating: 4.5,
        facilities: ['Free Wi-Fi', 'Swimming Pool', 'Restaurant'],
        imageUrl:
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
        availableRooms: 10,
        totalRooms: 100,
      ),
      Hotel(
        name: 'The Sunan Hotel Solo',
        location: 'Jl. Adi Sucipto',
        description:
            'Hotel mewah dengan fasilitas lengkap untuk bisnis dan liburan',
        rating: 4.7,
        facilities: ['Free Wi-Fi', 'Parking', 'Gym', 'Restaurant'],
        imageUrl:
            'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400',
        availableRooms: 15,
        totalRooms: 150,
      ),
      Hotel(
        name: 'Alila Solo',
        location: 'Jl. Slamet Riyadi',
        description: 'Hotel modern dengan pemandangan kota yang menakjubkan',
        rating: 4.8,
        facilities: ['Free Wi-Fi', 'Swimming Pool', 'Parking', 'Gym'],
        imageUrl:
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
        availableRooms: 20,
        totalRooms: 200,
      ),
      Hotel(
        name: 'Novotel Solo',
        location: 'Jl. Slamet Riyadi',
        description: 'Hotel internasional dengan standar pelayanan terbaik',
        rating: 4.6,
        facilities: ['Free Wi-Fi', 'Swimming Pool', 'Restaurant', 'Parking'],
        imageUrl:
            'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=400',
        availableRooms: 25,
        totalRooms: 180,
      ),
      Hotel(
        name: 'Lor In Hotel Solo',
        location: 'Jl. Adi Sucipto',
        description: 'Resort hotel dengan nuansa Jawa yang autentik',
        rating: 4.4,
        facilities: ['Free Wi-Fi', 'Parking', 'Restaurant'],
        imageUrl:
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=400',
        availableRooms: 12,
        totalRooms: 120,
      ),
      Hotel(
        name: 'Grand Orchid Solo',
        location: 'Jl. Slamet Riyadi',
        description:
            'Hotel bisnis dengan fasilitas lengkap di jantung kota Solo',
        rating: 4.3,
        facilities: [
          'Free Wi-Fi',
          'Swimming Pool',
          'Gym',
          'Restaurant',
          'Parking',
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=400',
        availableRooms: 18,
        totalRooms: 160,
      ),
    ];
  }

  static Future<bool> addHotel(Hotel hotel) async {
    try {
      final result = await HotelService.addHotel(hotel);
      if (result['success'] == true) {
        await loadHotels();
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error adding hotel: $e');
      return false;
    }
  }

  static Future<bool> deleteHotel(int index) async {
    try {
      if (index < _hotels.length && _hotels[index].id != null) {
        final result = await HotelService.deleteHotel(_hotels[index].id!);
        if (result['success'] == true) {
          await loadHotels();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('❌ Error deleting hotel: $e');
      return false;
    }
  }

  static Future<bool> updateHotel(int index, Hotel hotel) async {
    try {
      if (index < _hotels.length && _hotels[index].id != null) {
        final result = await HotelService.updateHotel(
          _hotels[index].id!,
          hotel,
        );
        if (result['success'] == true) {
          await loadHotels();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('❌ Error updating hotel: $e');
      return false;
    }
  }

  static Future<List<Hotel>> searchHotels(String query) async {
    try {
      return await HotelService.searchHotels(query);
    } catch (e) {
      print('❌ Error searching hotels: $e');
      return [];
    }
  }
}
