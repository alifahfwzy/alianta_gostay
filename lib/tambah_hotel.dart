import 'package:flutter/material.dart';
import 'services/hotel_service.dart';
import 'models/hotel.dart';

class TambahHotel extends StatefulWidget {
  const TambahHotel({super.key});

  @override
  State<TambahHotel> createState() => _TambahHotelState();
}

class _TambahHotelState extends State<TambahHotel> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaHotelController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _kontak1Controller = TextEditingController();
  final TextEditingController _kontak2Controller = TextEditingController();
  final TextEditingController _linkGambarController = TextEditingController();

  bool _freeWifi = false;
  bool _swimmingPool = false;
  bool _parking = false;
  bool _restaurant = false;
  bool _gym = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _namaHotelController.dispose();
    _deskripsiController.dispose();
    _alamatController.dispose();
    _kontak1Controller.dispose();
    _kontak2Controller.dispose();
    _linkGambarController.dispose();
    super.dispose();
  }

  Future<void> _simpanHotel() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Kumpulkan fasilitas yang dipilih
        List<String> selectedFacilities = [];
        if (_freeWifi) selectedFacilities.add('Free Wi-Fi');
        if (_swimmingPool) selectedFacilities.add('Swimming Pool');
        if (_parking) selectedFacilities.add('Parking');
        if (_restaurant) selectedFacilities.add('Restaurant');
        if (_gym) selectedFacilities.add('Gym');

        // Buat objek hotel baru
        Hotel newHotel = Hotel(
          name: _namaHotelController.text,
          location: _alamatController.text,
          facilities: selectedFacilities,
          imageUrl:
              _linkGambarController.text.isEmpty
                  ? 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400'
                  : _linkGambarController.text,
          rating: 4.0, // Default rating
        );

        // Simpan ke database
        await HotelService.addHotel(newHotel);

        // Tampilkan pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hotel "${newHotel.name}" berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );

        // Kembali ke halaman sebelumnya
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan hotel: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Tambah Hotel'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(
                controller: _namaHotelController,
                labelText: 'Nama Hotel',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _deskripsiController,
                labelText: 'Deskripsi',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _alamatController,
                labelText: 'Alamat',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _kontak1Controller,
                labelText: 'Kontak 1',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _kontak2Controller,
                labelText: 'Kontak 2 (Opsional)',
                keyboardType: TextInputType.phone,
                isOptional: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _linkGambarController,
                labelText: 'Link Gambar',
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              const Text(
                'Fasilitas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildCheckbox(
                title: 'Free Wi-Fi',
                value: _freeWifi,
                onChanged: (bool? value) {
                  setState(() {
                    _freeWifi = value ?? false;
                  });
                },
              ),
              _buildCheckbox(
                title: 'Swimming Pool',
                value: _swimmingPool,
                onChanged: (bool? value) {
                  setState(() {
                    _swimmingPool = value ?? false;
                  });
                },
              ),
              _buildCheckbox(
                title: 'Parking',
                value: _parking,
                onChanged: (bool? value) {
                  setState(() {
                    _parking = value ?? false;
                  });
                },
              ),
              _buildCheckbox(
                title: 'Restaurant',
                value: _restaurant,
                onChanged: (bool? value) {
                  setState(() {
                    _restaurant = value ?? false;
                  });
                },
              ),
              _buildCheckbox(
                title: 'Gym',
                value: _gym,
                onChanged: (bool? value) {
                  setState(() {
                    _gym = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _isLoading ? null : _simpanHotel,
          child:
              _isLoading
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : const Text(
                    'Tambahkan',
                    style: TextStyle(color: Colors.white),
                  ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool isOptional = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (!isOptional && (value == null || value.isEmpty)) {
          return '$labelText tidak boleh kosong';
        }
        if (keyboardType == TextInputType.url &&
            value != null &&
            value.isNotEmpty &&
            !Uri.parse(value).isAbsolute) {
          return 'Link gambar tidak valid';
        }
        if (keyboardType == TextInputType.phone &&
            value != null &&
            value.isNotEmpty &&
            !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Kontak tidak valid';
        }
        return null;
      },
    );
  }

  Widget _buildCheckbox({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: Colors.blue,
    );
  }
}
