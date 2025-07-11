# Sistem Login GoStay

## Cara Kerja Sistem Login

### 1. **Registrasi User Baru**

- User harus membuat akun terlebih dahulu melalui halaman "Buat Akun"
- Data user akan disimpan di tabel `users` di database Supabase
- Validasi email format dan password minimal 5 karakter
- Cek duplikat email untuk memastikan uniqueness

### 2. **Proses Login**

- User memasukkan email dan password
- Sistem akan cek apakah email terdaftar di database
- Jika email tidak ditemukan, user akan diarahkan untuk buat akun
- Jika email ada tapi password salah, akan muncul pesan error
- Jika berhasil, user akan diarahkan ke halaman beranda

### 3. **Validasi dan Error Handling**

#### Error Types:

- `user_not_found`: Email belum terdaftar
- `wrong_password`: Password salah
- `database_not_configured`: Database belum setup
- `system_error`: Error sistem lainnya

#### User Experience:

- Jika email belum terdaftar, muncul dialog untuk membuat akun
- Loading indicator saat proses login
- Pesan error yang informatif dan user-friendly

## Implementasi Teknis

### 1. **UserService.loginUser()**

```dart
// Cek keberadaan user
final userCheck = await _client
    .from('users')
    .select('id, email, username')
    .eq('email', email)
    .maybeSingle();

if (userCheck == null) {
    return {
        'success': false,
        'message': 'Email belum terdaftar. Silakan buat akun terlebih dahulu.',
        'error_type': 'user_not_found'
    };
}

// Validasi password
final response = await _client
    .from('users')
    .select()
    .eq('email', email)
    .eq('password', password)
    .maybeSingle();
```

### 2. **Login UI dengan Validasi**

```dart
// Handler login dengan loading state
Future<void> _handleLogin() async {
    _setLoading(true);

    final result = await UserService.loginUser(
        email: email,
        password: password,
    );

    if (result['success']) {
        // Redirect ke beranda
        Navigator.pushReplacement(context, ...);
    } else {
        // Handle error berdasarkan type
        if (result['error_type'] == 'user_not_found') {
            _showCreateAccountDialog();
        }
    }

    _setLoading(false);
}
```

### 3. **Dialog Konfirmasi Buat Akun**

```dart
void _showCreateAccountDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('Belum Memiliki Akun?'),
            content: Text('Anda harus membuat akun terlebih dahulu...'),
            actions: [
                TextButton(child: Text('Batal'), onPressed: () => Navigator.pop(context)),
                ElevatedButton(
                    child: Text('Buat Akun'),
                    onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BuatAkun()));
                    },
                ),
            ],
        ),
    );
}
```

## Test Scenario

### 1. **Test User Belum Terdaftar**

1. Buka halaman login
2. Masukkan email yang belum terdaftar (contoh: `newuser@test.com`)
3. Masukkan password apa saja
4. Klik tombol "Masuk"
5. **Expected**: Muncul dialog "Belum Memiliki Akun?" dan redirect ke halaman registrasi

### 2. **Test User Sudah Terdaftar - Password Salah**

1. Gunakan test user: `test@gostay.com`
2. Masukkan password yang salah
3. Klik tombol "Masuk"
4. **Expected**: Muncul pesan "Password salah"

### 3. **Test User Sudah Terdaftar - Login Berhasil**

1. Gunakan test user: `test@gostay.com`
2. Masukkan password yang benar: `test123`
3. Klik tombol "Masuk"
4. **Expected**: Login berhasil dan redirect ke beranda

## Akun Test yang Tersedia

### Test User (Auto-generated):

```
Email: test@gostay.com
Password: test123
Username: Test User
```

### Admin User:

```
Email: admin@gostay.com
Password: admin123
Username: Admin GoStay
```

## Keamanan

⚠️ **Catatan Penting**: Dalam implementasi production, pastikan:

- Password di-hash menggunakan bcrypt atau algoritma yang aman
- Implementasi rate limiting untuk mencegah brute force attack
- Validasi input yang ketat di sisi server
- Gunakan HTTPS untuk semua komunikasi
- Implementasi session management yang aman

## Debugging

### Console Log Messages:

- `🔑 Mencoba login: [email]` - Proses login dimulai
- `❌ User tidak ditemukan: [email]` - Email belum terdaftar
- `❌ Password salah untuk: [email]` - Password tidak cocok
- `✅ Login berhasil: [email]` - Login berhasil
- `🧪 Kredensial test user:` - Info test user yang dibuat

### Troubleshooting:

1. **Tidak bisa login**: Pastikan database sudah setup dan user sudah terdaftar
2. **Error tabel tidak ditemukan**: Jalankan SQL setup dari `DATABASE_SETUP.md`
3. **Loading terus menerus**: Cek koneksi internet dan konfigurasi Supabase
