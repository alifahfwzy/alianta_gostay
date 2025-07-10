# GoStay Database Setup Guide

## SQL Commands untuk Setup Database Supabase

Jalankan SQL commands berikut di Supabase SQL Editor untuk membuat tabel dan data yang diperlukan:

### 1. Tabel Users

```sql
-- Create users table
CREATE TABLE IF NOT EXISTS public.users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    username VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Enable RLS (Row Level Security)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Create policy for users table
CREATE POLICY "Enable read access for all users" ON public.users
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for all users" ON public.users
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Enable update for users based on id" ON public.users
    FOR UPDATE USING (auth.uid() = id);
```

### 2. Tabel Hotels

```sql
-- Create hotels table
CREATE TABLE IF NOT EXISTS public.hotels (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    facilities TEXT[] DEFAULT '{}',
    image_url TEXT DEFAULT 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
    rating DECIMAL(3,2) DEFAULT 0.0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Enable RLS
ALTER TABLE public.hotels ENABLE ROW LEVEL SECURITY;

-- Create policy for hotels table
CREATE POLICY "Enable read access for all users" ON public.hotels
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users" ON public.hotels
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Enable update for authenticated users" ON public.hotels
    FOR UPDATE USING (true);

CREATE POLICY "Enable delete for authenticated users" ON public.hotels
    FOR DELETE USING (true);
```

### 3. Tabel Admins

```sql
-- Create admins table
CREATE TABLE IF NOT EXISTS public.admins (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Enable RLS
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;

-- Create policy for admins table
CREATE POLICY "Enable read access for all users" ON public.admins
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for all users" ON public.admins
    FOR INSERT WITH CHECK (true);
```

### 4. Insert Sample Data

#### Sample Hotels Data:

```sql
INSERT INTO public.hotels (name, location, facilities, image_url, rating) VALUES
('Hotel Sahid Jaya Solo', 'Jl. Gajah Mada No.82, Banjarsari, Kota Surakarta',
 ARRAY['Free Wi-Fi', 'Restaurant', 'Parking', 'AC'],
 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400', 4.5),

('The Sunan Hotel Solo', 'Jl. Adi Sucipto No.47, Jajar, Laweyan, Kota Surakarta',
 ARRAY['Free Wi-Fi', 'Swimming Pool', 'Spa', 'Restaurant'],
 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400', 4.7),

('Alila Solo', 'Jl. Slamet Riyadi No.562, Pajang, Laweyan, Kota Surakarta',
 ARRAY['Free Wi-Fi', 'Gym', 'Restaurant', 'Conference Room'],
 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400', 4.8),

('Novotel Solo', 'Jl. Slamet Riyadi No.366, Windan, Makamhaji, Kartasura',
 ARRAY['Free Wi-Fi', 'Swimming Pool', 'Fitness Center', 'Business Center'],
 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=400', 4.6),

('Lor In Hotel Solo', 'Jl. Adi Sucipto No.47A, Jajar, Laweyan, Kota Surakarta',
 ARRAY['Free Wi-Fi', 'Restaurant', 'Meeting Room'],
 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400', 4.4);
```

#### Default Admin:

```sql
INSERT INTO public.admins (username, password, email, name) VALUES
('admin gostay', 'aliantagostay', 'admin@gostay.com', 'Administrator GoStay');
```

### 5. Create Functions for Updated Timestamps

```sql
-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_hotels_updated_at BEFORE UPDATE ON public.hotels
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_admins_updated_at BEFORE UPDATE ON public.admins
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

## Cara Setup:

1. **Buka Supabase Dashboard**: https://supabase.com/dashboard
2. **Pilih Project**: Pilih project `alianta-gostay`
3. **Buka SQL Editor**: Klik "SQL Editor" di sidebar
4. **Jalankan SQL**: Copy dan paste SQL commands di atas satu per satu
5. **Verifikasi**: Cek di "Table Editor" apakah tabel sudah terbuat

## Environment Variables

Pastikan credentials Supabase sudah benar di `lib/config/supabase_config.dart`:

- `supabaseUrl`: https://cckwnkzywmqteyfpsd.supabase.co
- `supabaseAnonKey`: Anon key dari project settings

## Testing Koneksi

Aplikasi akan otomatis test koneksi saat startup dan membuat admin default jika belum ada.

## Default Credentials

**Admin Login:**

- Username: `admin gostay`
- Password: `aliantagostay`

**Test User (buat manual via app):**

- Email: test@gostay.com
- Password: test123
- Username: Test User

## Troubleshooting

Jika ada error:

1. Pastikan RLS policies sudah dibuat
2. Check koneksi internet
3. Verify Supabase URL dan API key
4. Check console log untuk error details
