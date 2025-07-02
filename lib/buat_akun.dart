import 'package:flutter/material.dart';
import 'beranda.dart';

class BuatAkun extends StatefulWidget {
  const BuatAkun({super.key});

  @override
  State<BuatAkun> createState() => _BuatAkunState();
}

class _BuatAkunState extends State<BuatAkun> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol kembali dan judul
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Buat Akun',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Input fields
              buildTextField(_emailController, 'Masukkan Email'),
              const SizedBox(height: 12),
              buildTextField(
                _passwordController,
                'Masukkan Password',
                obscureText: true,
              ),
              const SizedBox(height: 12),
              buildTextField(
                _confirmPasswordController,
                'Konfirmasi Password',
                obscureText: true,
              ),
              const SizedBox(height: 12),
              buildTextField(_usernameController, 'Masukkan Nama Pengguna'),
              const SizedBox(height: 12),
              buildTextField(_phoneController, 'Masukkan No Hp'),
              const SizedBox(height: 12),
              buildTextField(_addressController, 'Masukkan Alamat'),
              const SizedBox(height: 24),
              // Tombol daftar
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Validasi form (sederhana)
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    String confirmPassword = _confirmPasswordController.text;
                    String username = _usernameController.text;
                    
                    if (email.isNotEmpty && password.isNotEmpty && 
                        confirmPassword.isNotEmpty && username.isNotEmpty) {
                      if (password == confirmPassword) {
                        // Navigate to Beranda after successful registration
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BerandaPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password dan konfirmasi password tidak sama'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Semua field harus diisi'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String hintText, {
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
