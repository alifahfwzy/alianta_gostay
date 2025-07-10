import 'package:flutter/material.dart';
import 'beranda.dart';
import 'explore_page.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String _namaPengguna = 'Nama Pengguna';
  bool _isEditing = false;
  late TextEditingController _controllerNama;

  @override
  void initState() {
    super.initState();
    _controllerNama = TextEditingController(text: _namaPengguna);
  }

  @override
  void dispose() {
    _controllerNama.dispose();
    super.dispose();
  }

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
            _isEditing
                ? TextField(
                    controller: _controllerNama,
                    decoration: const InputDecoration(
                      labelText: 'Nama Pengguna',
                      border: OutlineInputBorder(),
                    ),
                  )
                : Text(
                    _namaPengguna,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
            const SizedBox(height: 8),
            const Text(
              'namauser@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              'Akun Terdaftar',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  if (_isEditing) {
                    _namaPengguna = _controllerNama.text;
                  }
                  _isEditing = !_isEditing;
                });
              },
              child: Text(_isEditing ? 'Simpan' : 'Edit Nama'),
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Bergabung sejak:', style: TextStyle(fontSize: 16)),
                Text('2023', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Status Akun:', style: TextStyle(fontSize: 16)),
                Text('Aktif', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green)),
              ],
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
