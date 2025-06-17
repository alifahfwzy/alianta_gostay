import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            'GoStay',
            style: TextStyle(
              fontSize: 60, // Increased font size
              fontWeight: FontWeight.bold,
              color: Colors.white, // Changed text color for better contrast
              shadows: [
                // Added a subtle shadow for depth
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(5.0, 5.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
