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

  double? _rating;
  String? _previewImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.hotel != null) {
      _namaHotelController.text = widget.hotel!.name;
      _alamatController.text = widget.hotel!.location;
      _deskripsiController.text = widget.hotel!.description;
      _linkGambarController.text = widget.hotel!.imageUrl ?? '';
      _rating = widget.hotel!.rating;

      _freeWifi = widget.hotel!.facilities.contains('Free Wi-Fi');
      _swimmingPool = widget.hotel!.facilities.contains('Swimming Pool');
      _parking = widget.hotel!.facilities.contains('Parking');
      _restaurant = widget.hotel!.facilities.contains('Restaurant');
      _gym = widget.hotel!.facilities.contains('Gym');

      _previewImageUrl = widget.hotel!.imageUrl;
    }

    _linkGambarController.addListener(() {
      final link = _linkGambarController.text.trim();
      if (Uri.tryParse(link)?.isAbsolute == true) {
        setState(() {
          _previewImageUrl = link;
        });
      } else {
        setState(() {
          _previewImageUrl = null;
        });
      }
    });
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
        List<String> selectedFacilities = [];
        if (_freeWifi) selectedFacilities.add('Free Wi-Fi');
        if (_swimmingPool) selectedFacilities.add('Swimming Pool');
        if (_parking) selectedFacilities.add('Parking');
        if (_restaurant) selectedFacilities.add('Restaurant');
        if (_gym) selectedFacilities.add('Gym');

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
          rating: _rating ?? 4.0,
        );

        Map<String, dynamic> result;
        if (widget.hotel == null) {
          result = await HotelService.addHotel(hotel);
        } else {
          result = await HotelService.updateHotel(widget.hotel!.id!, hotel);
        }

        if (result['success'] == true) {
          Navigator.pop(context, true);
        } else {
          _showErrorMessage(result['message'] ?? 'Gagal menyimpan hotel');
        }
      } catch (e) {
        _showErrorMessage('Error: ${e.toString()}');
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
                TextFormField(
                  controller: _namaHotelController,
                  decoration: InputDecoration(
                    labelText: 'Nama Hotel',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Nama hotel harus diisi'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Alamat harus diisi'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _deskripsiController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Deskripsi harus diisi'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _linkGambarController,
                  decoration: InputDecoration(
                    labelText: 'Link Gambar',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'https://example.com/image.jpg',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final uri = Uri.tryParse(value);
                    if (uri == null || (!uri.isAbsolute)) {
                      return 'Masukkan URL gambar yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                if (_previewImageUrl != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preview Gambar:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) => Dialog(
                                  backgroundColor: Colors.black,
                                  child: InteractiveViewer(
                                    child: Image.network(
                                      _previewImageUrl!,
                                      fit: BoxFit.contain,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            'Gagal memuat gambar',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            _previewImageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                alignment: Alignment.center,
                                child: const Text('Gagal memuat gambar'),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                const Text(
                  'Fasilitas Hotel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  title: const Text('Free Wi-Fi'),
                  value: _freeWifi,
                  onChanged: (val) => setState(() => _freeWifi = val ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Swimming '),
                  value: _swimmingPool,
                  onChanged:
                      (val) => setState(() => _swimmingPool = val ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Parking'),
                  value: _parking,
                  onChanged: (val) => setState(() => _parking = val ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Restaurant'),
                  value: _restaurant,
                  onChanged:
                      (val) => setState(() => _restaurant = val ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Gym'),
                  value: _gym,
                  onChanged: (val) => setState(() => _gym = val ?? false),
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<double>(
                  value: _rating,
                  decoration: InputDecoration(
                    labelText: 'Rating Hotel (1.0 - 5.0)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items:
                      [1.0, 2.0, 3.0, 4.0, 5.0].map((value) {
                        return DropdownMenuItem<double>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) return 'Rating harus dipilih';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _simpanHotel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 214, 209, 209),
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
