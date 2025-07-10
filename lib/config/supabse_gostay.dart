import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseGoStay {
  static const String supabaseUrl = 'https://cckwvnkxzywmqteyfpsd.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNja3d2bmt4enl3bXF0ZXlmcHNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIxMTYwNTUsImV4cCI6MjA2NzY5MjA1NX0.DrFg4NRIM8abfMEaBdnbrT1-uw75p2QoTnoXZmzOP_o';

  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
