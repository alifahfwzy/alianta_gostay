import 'package:flutter/material.dart';
import 'beranda.dart';
import 'explore_page.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/images/profile.jpg',
              ), // ganti path ini sesuai asset kamu
            ),
            const SizedBox(height: 16),
            const Text(
              'Nama Pengguna',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'namauser@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Nomor Telepon'),
              subtitle: const Text('+62 812-3456-7890'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Alamat'),
              subtitle: const Text('Jl. Contoh Alamat No.123'),
              onTap: () {},
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // aksi logout atau lainnya
                },
                child: const Text(
                  'Keluar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Profile is selected
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigate to Beranda page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BerandaPage()),
              );
              break;
            case 1:
              // Navigate to Explore page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExplorePage()),
              );
              break;
            case 2:
              // Already on Profile page, do nothing
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
