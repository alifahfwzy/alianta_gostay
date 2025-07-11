import 'package:flutter/material.dart';
import 'models/hotel.dart';

class TampilanDetailHotel extends StatelessWidget {
  final Hotel hotel;

  const TampilanDetailHotel({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
            // Gambar Hotel
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                hotel.imageUrl ?? '',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: Text('#gambarhotel')),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Rating & Nama Hotel
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(hotel.rating.toString(), style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              hotel.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            const Text(
              'Experience luxury and comfort at this hotel...',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            const Text('Fasilitas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: hotel.facilities.map((fasilitas) {
                IconData icon;
                switch (fasilitas.toLowerCase()) {
                  case 'wifi': icon = Icons.wifi; break;
                  case 'ac': icon = Icons.ac_unit; break;
                  case 'restaurant': icon = Icons.restaurant; break;
                  case 'spa': icon = Icons.spa; break;
                  case 'pool': icon = Icons.pool; break;
                  case 'gym': icon = Icons.fitness_center; break;
                  default: icon = Icons.check_circle_outline;
                }
                return _facilityItem(icon, fasilitas);
              }).toList(),
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hotel.location,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _facilityItem(IconData icon, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Colors.black54),
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
