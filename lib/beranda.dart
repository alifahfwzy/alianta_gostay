import 'package:flutter/material.dart';
import 'explore_page.dart';
import 'profil.dart';
import 'services/hotel_service.dart';
import 'models/hotel.dart';

// Database untuk hotel yang terintegrasi dengan Supabase
class HotelDatabase {
  static List<Hotel> _hotels = [];

  static List<Hotel> get hotels => _hotels;

  // Load hotels dari Supabase
  static Future<void> loadHotels() async {
    try {
      _hotels = await HotelService.getAllHotels();
      debugPrint('✅ Berhasil load ${_hotels.length} hotel dari database');
    } catch (e) {
      debugPrint('❌ Error loading hotels: $e');
      // Fallback ke data dummy jika error
      // _hotels = _getDummyHotels();
    }
  }

  // Add hotel ke Supabase
  static Future<bool> addHotel(Hotel hotel) async {
    try {
      final result = await HotelService.addHotel(hotel);
      if (result['success'] == true) {
        await loadHotels(); // Refresh local data
        debugPrint('✅ Hotel berhasil ditambah ke database');
        return true;
      } else {
        debugPrint('❌ Gagal menambah hotel: ${result['message']}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error adding hotel: $e');
      return false;
    }
  }

  // Delete hotel dari Supabase
  static Future<bool> deleteHotel(int index) async {
    try {
      if (index < _hotels.length && _hotels[index].id != null) {
        final result = await HotelService.deleteHotel(_hotels[index].id!);
        if (result['success'] == true) {
          await loadHotels(); // Refresh local data
          debugPrint('✅ Hotel berhasil dihapus dari database');
          return true;
        } else {
          debugPrint('❌ Gagal menghapus hotel: ${result['message']}');
          return false;
        }
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error deleting hotel: $e');
      return false;
    }
  }

  // Update hotel di Supabase
  static Future<bool> updateHotel(int index, Hotel hotel) async {
    try {
      if (index < _hotels.length && _hotels[index].id != null) {
        final result = await HotelService.updateHotel(
          _hotels[index].id!,
          hotel,
        );
        if (result['success'] == true) {
          await loadHotels(); // Refresh local data
          debugPrint('✅ Hotel berhasil diupdate di database');
          return true;
        } else {
          debugPrint('❌ Gagal mengupdate hotel: ${result['message']}');
          return false;
        }
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error updating hotel: $e');
      return false;
    }
  }

  // Search hotels dari Supabase
  static Future<List<Hotel>> searchHotels(String query) async {
    try {
      return await HotelService.searchHotels(query);
    } catch (e) {
      debugPrint('❌ Error searching hotels: $e');
      return [];
    }
  }
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    HotelDatabase.loadHotels().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Method untuk mendapatkan icon fasilitas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Beranda',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF29B6F6),
        automaticallyImplyLeading: false,
        elevation: 3,
        shadowColor: Colors.black26,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Selamat Datang di Solo!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Jelajahi berbagai rekomendasi hotel terbaik di Kota Solo',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section Title
              const Text(
                'Hotel Terbaik di Solo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Hotel List
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : HotelDatabase.hotels.isEmpty
                  ? const Center(child: Text('Tidak ada hotel tersedia'))
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: HotelDatabase.hotels.length,
                    itemBuilder: (context, index) {
                      final hotel = HotelDatabase.hotels[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Hotel Image
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: Image.network(
                                    hotel.imageUrl ??
                                        'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                        ),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF29B6F6),
                                                ),
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.image,
                                                size: 30,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                'Foto Hotel',
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Hotel Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Hotel Name
                                    Text(
                                      hotel.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Location
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            hotel.location,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),

                                    // Rating
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          hotel.rating?.toString() ?? '-',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF29B6F6),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            switch (index) {
              case 0:
                // Already on Beranda, do nothing
                break;
              case 1:
                // Navigate to Explore page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExplorePage()),
                );
                break;
              case 2:
                // Navigate to Profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profil()),
                );
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
