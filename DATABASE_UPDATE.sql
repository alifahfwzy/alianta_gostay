-- SQL Script untuk menambahkan kolom yang hilang di tabel hotels
-- Jalankan script ini di Supabase SQL Editor

-- Tambahkan kolom description ke tabel hotels
ALTER TABLE public.hotels ADD COLUMN IF NOT EXISTS description TEXT DEFAULT 'Hotel yang nyaman dengan fasilitas lengkap';

-- Tambahkan kolom available_rooms ke tabel hotels  
ALTER TABLE public.hotels ADD COLUMN IF NOT EXISTS available_rooms INTEGER DEFAULT 10;

-- Tambahkan kolom total_rooms ke tabel hotels
ALTER TABLE public.hotels ADD COLUMN IF NOT EXISTS total_rooms INTEGER DEFAULT 20;

-- Update data yang sudah ada dengan nilai default
UPDATE public.hotels 
SET 
    description = 'Hotel yang nyaman dengan fasilitas lengkap dan pelayanan terbaik' 
WHERE description IS NULL OR description = '';

UPDATE public.hotels 
SET available_rooms = 10 
WHERE available_rooms IS NULL;

UPDATE public.hotels 
SET total_rooms = 20 
WHERE total_rooms IS NULL;

-- Tampilkan struktur tabel setelah update
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'hotels' AND table_schema = 'public'
ORDER BY ordinal_position;
