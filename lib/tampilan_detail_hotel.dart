import 'package:flutter/material.dart';

class TampilanDetailHotel extends StatefulWidget {
  const TampilanDetailHotel({super.key});

  @override
  State<TampilanDetailHotel> createState() => _TampilanDetailHotelState();
}

class _TampilanDetailHotelState extends State<TampilanDetailHotel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Hotel (Placeholder)
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: const Center(
                child: Text(
                  '#gambarhotel',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Rating & Nama Hotel
            Row(
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 4),
                Text(
                  '4.0',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),

            const Text(
              'The Grand Majestic Hotel',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              'Experience luxury and comfort at The Grand Majestic Hotel, located in the heart of the city. Enjoy our world-class amenities and impeccable service.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            const Text(
              'Fasilitas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _facilityItem(Icons.pool, 'Swimming\nPool'),
                _facilityItem(Icons.wifi, 'Free Wi-Fi'),
                _facilityItem(Icons.local_parking, 'Parking'),
                _facilityItem(Icons.restaurant, 'Restaurant'),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.location_on, color: Colors.black54),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Getting there\nAddress: 123 Main Street',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget fasilitas
  static Widget _facilityItem(IconData icon, String label) {
    return Container(
      width: 70,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.black54),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}