import 'package:flutter/material.dart';
import 'models/hotel.dart';
import 'services/hotel_service_new.dart';

class TambahHotel extends StatefulWidget {
  final Hotel? hotel;

  const TambahHotel({Key? key, this.hotel}) : super(key: key);

  @override
  State<TambahHotel> createState() => _TambahHotelState();
}

class _TambahHotelState extends State<TambahHotel> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaHotelController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _linkGambarController = TextEditingController();

  bool _freeWifi = false;
  bool _swimmingPool = false;
  bool _parking = false;
  bool _restaurant = false;
  bool _gym = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Mengisi form dengan data hotel yang ada jika dalam mode edit
    if (widget.hotel != null) {
      _namaHotelController.text = widget.hotel!.name;
      _alamatController.text = widget.hotel!.location;
      _deskripsiController.text = widget.hotel!.description ?? '';
      _linkGambarController.text = widget.hotel!.imageUrl ?? '';
      print('Debug - Description: ${widget.hotel!.description}'); // Debug line

      // Mengatur fasilitas yang ada
      _freeWifi = widget.hotel!.facilities.contains('Free Wi-Fi');
      _swimmingPool = widget.hotel!.facilities.contains('Swimming Pool');
      _parking = widget.hotel!.facilities.contains('Parking');
      _restaurant = widget.hotel!.facilities.contains('Restaurant');
      _gym = widget.hotel!.facilities.contains('Gym');
    }
  }

  @override
  void dispose() {
    _namaHotelController.dispose();
    _deskripsiController.dispose();
    _alamatController.dispose();
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

        // Buat objek hotel
        print(
          'Debug - Saving description: ${_deskripsiController.text}',
        ); // Debug line

        Hotel hotel = Hotel(
          id: widget.hotel?.id,
          name: _namaHotelController.text.trim(),
          location: _alamatController.text.trim(),
          description: _deskripsiController.text.trim(),
          facilities: selectedFacilities,
          imageUrl:
              _linkGambarController.text.trim().isEmpty
                  ? 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400'
                  : _linkGambarController.text.trim(),
          rating: widget.hotel?.rating ?? 0.0,
          availableRooms: widget.hotel?.availableRooms ?? 0,
          totalRooms: widget.hotel?.totalRooms ?? 0,
        );

        // Simpan atau update hotel
        Map<String, dynamic> result;
        if (widget.hotel == null) {
          print('Debug - Adding new hotel: ${hotel.toJson()}');
          result = await HotelService.addHotel(hotel);
        } else {
          print('Debug - Updating hotel with ID: ${widget.hotel!.id}');
          print('Debug - Update data: ${hotel.toJson()}');
          result = await HotelService.updateHotel(widget.hotel!.id!, hotel);
        }

        if (result['success'] == true) {
          Navigator.pop(context, true);
        } else {
          _showErrorMessage('Gagal menyimpan hotel');
        }
      } catch (e) {
        _showErrorMessage('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.hotel == null ? 'Tambah Hotel' : 'Edit Hotel',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Nama Hotel
                TextFormField(
                  controller: _namaHotelController,
                  decoration: InputDecoration(
                    labelText: 'Nama Hotel',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama hotel harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Alamat
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat harus diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Deskripsi
                TextFormField(
                  controller: _deskripsiController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi harus diisi';
                    }
                    if (value.length < 20) {
                      return 'Deskripsi minimal 20 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Link Gambar
                TextFormField(
                  controller: _linkGambarController,
                  decoration: InputDecoration(
                    labelText: 'Link Gambar',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'https://example.com/image.jpg',
                  ),
                ),
                const SizedBox(height: 24),

                // Fasilitas Section
                const Text(
                  'Fasilitas Hotel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Checkbox Fasilitas
                CheckboxListTile(
                  title: const Text('Free Wi-Fi'),
                  value: _freeWifi,
                  onChanged: (bool? value) {
                    setState(() {
                      _freeWifi = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Swimming Pool'),
                  value: _swimmingPool,
                  onChanged: (bool? value) {
                    setState(() {
                      _swimmingPool = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Parking'),
                  value: _parking,
                  onChanged: (bool? value) {
                    setState(() {
                      _parking = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Restaurant'),
                  value: _restaurant,
                  onChanged: (bool? value) {
                    setState(() {
                      _restaurant = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Gym'),
                  value: _gym,
                  onChanged: (bool? value) {
                    setState(() {
                      _gym = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _simpanHotel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(
                            widget.hotel == null
                                ? 'Tambah Hotel'
                                : 'Simpan Perubahan',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
