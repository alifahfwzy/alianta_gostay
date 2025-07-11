# GoStay - Hotel Booking App

Aplikasi Flutter untuk booking hotel dengan sistem login yang terintegrasi dengan Supabase.

## Fitur Utama

- ✅ **Sistem Login/Register User** - Hanya user yang terdaftar yang bisa login
- ✅ **Sistem Login Admin** - Panel admin untuk mengelola hotel
- ✅ **Database Supabase** - Penyimpanan data user dan hotel yang aman
- ✅ **Validasi Login** - Memastikan user harus buat akun sebelum login
- ✅ **UI Modern** - Desain yang menarik dan user-friendly

## Sistem Login

### Untuk User Biasa:

1. **Buat Akun Dulu**: User harus registrasi terlebih dahulu sebelum bisa login
2. **Login**: Setelah punya akun, bisa login dengan email dan password
3. **Validasi**: Sistem akan cek apakah user sudah terdaftar di database

### Test User (untuk Development):

```
Email: test@gostay.com
Password: test123
Username: Test User
```

### Admin Login:

```
Email: admin@gostay.com
Password: admin123
```

## Setup Database

1. **Buat Project Supabase**:

   - Buka [Supabase Dashboard](https://supabase.com/dashboard)
   - Buat project baru
   - Catat URL dan API Key

2. **Konfigurasi Database**:

   - Jalankan SQL commands dari `DATABASE_SETUP.md`
   - Pastikan semua tabel dibuat dengan benar

3. **Test Koneksi**:
   - Jalankan aplikasi
   - Cek console log untuk status koneksi database

## Cara Menjalankan

```bash
# Clone repository
git clone [repository-url]

# Install dependencies
flutter pub get

# Run aplikasi
flutter run
```

## Struktur Project

```
lib/
├── config/
│   ├── supabase_config.dart    # Konfigurasi Supabase
│   └── setup_db.dart           # Setup dan validasi database
├── models/
│   ├── user.dart               # Model User
│   ├── admin.dart              # Model Admin
│   └── hotel.dart              # Model Hotel
├── services/
│   ├── user_service.dart       # Service untuk operasi User
│   ├── admin_service.dart      # Service untuk operasi Admin
│   └── hotel_service.dart      # Service untuk operasi Hotel
├── login_user.dart             # Halaman login user
├── buat_akun.dart              # Halaman registrasi user
├── login_admin.dart            # Halaman login admin
└── main.dart                   # Entry point aplikasi
```

## Troubleshooting

### Error "Tabel tidak ditemukan"

- Pastikan sudah menjalankan SQL commands dari `DATABASE_SETUP.md`
- Cek apakah tabel sudah dibuat di Supabase Dashboard

### Error "Email belum terdaftar"

- User harus registrasi terlebih dahulu melalui halaman "Buat Akun"
- Pastikan data tersimpan di database users

### Error Koneksi Database

- Cek konfigurasi Supabase URL dan API Key
- Pastikan koneksi internet stabil

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
