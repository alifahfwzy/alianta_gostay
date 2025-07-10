# Troubleshooting GoStay

## Masalah Umum dan Solusinya

### 1. Error: "Failed to fetch, uri=https://cckwnkzywmqteyfpsd.supabase.co/rest/v1/users"

Masalah ini muncul karena URL Supabase tidak valid atau tabel users tidak ada.

**Solusi:**

1. **Periksa URL Supabase**

   Pastikan URL di file `lib/config/supabase_config.dart` dan `lib/config/supabse_gostay.dart` sudah benar:

   ```dart
   static const String supabaseUrl = 'https://cckvnkxzywmqteyfpsd.supabase.co';
   ```

   Jika URL masih salah, dapatkan URL yang benar dari Supabase Dashboard > Settings > API.

2. **Buat Tabel Users Manual**

   Jika URL sudah benar tapi masih error, buat tabel users secara manual:

   a. Login ke [Supabase Dashboard](https://app.supabase.com)
   b. Pilih project Anda
   c. Navigasi ke "Table Editor"
   d. Klik "New Table"
   e. Isi informasi tabel:

   - Name: `users`
   - Columns: - `id` (UUID, primary key, default: `gen_random_uuid()`) - `email` (varchar, NOT NULL, UNIQUE) - `password` (varchar, NOT NULL) - `username` (varchar, NOT NULL) - `created_at` (timestamp, default: `now()`) - `updated_at` (timestamp, default: `now()`)
     f. Klik "Save"
     g. Setelah tabel dibuat, aktifkan Row Level Security (RLS)
     h. Tambahkan policy berikut:
   - Allow read access to everyone
   - Allow insert to everyone
   - Allow update to everyone

3. **Periksa Anon Key**

   Pastikan anon key di file konfigurasi sama dengan yang ada di Supabase Dashboard > Settings > API > Project API keys > anon public.

### 2. Error RPC exec_sql not found

Fungsi `exec_sql` tidak tersedia di Supabase secara default.

**Solusi:**

1. Buka Supabase Dashboard > SQL Editor
2. Jalankan SQL berikut untuk membuat fungsi RPC:

   ```sql
   create or replace function exec_sql(query text)
   returns void as $$
   begin
     execute query;
   end;
   $$ language plpgsql security definer;
   ```

3. Alternatifnya, buat tabel secara manual seperti dijelaskan di atas.

### 3. Tips Debugging

1. Gunakan log untuk melihat detail error:

   ```dart
   print('❌ Error: $e');
   ```

2. Periksa log di console Flutter ketika mendapatkan error.

3. Untuk memastikan tabel sudah ada, coba jalankan query sederhana di Supabase Dashboard > SQL Editor:

   ```sql
   SELECT * FROM users LIMIT 1;
   ```

4. Restart aplikasi setelah melakukan perubahan konfigurasi.

Jika masalah masih berlanjut, hubungi tim pengembang atau buat issue di repository.
