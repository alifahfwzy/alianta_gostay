import 'package:flutter/material.dart';
import 'login_user.dart';

class TampilanAwal extends StatefulWidget {
  const TampilanAwal({super.key});

  @override
  State<TampilanAwal> createState() => _TampilanAwalState();
}

class _TampilanAwalState extends State<TampilanAwal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Section with Gradient Background
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo/Icon Container
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.hotel,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Main Title
                      const Text(
                        'Welcome to Your\nNext Stay',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Subtitle
                      const Text(
                        'GoStay - Your Perfect Stay Companion',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom Section
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // "Cari Sekarang" Title
                    const Text(
                      'Cari Sekarang',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Description
                    const Text(
                      'Temukan hotel menakjubkan dan nikmati kebebasan bermain saat anda tiba bersama orang tersayang',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // "Masuk" Button
                    SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginUser(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF29B6F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
