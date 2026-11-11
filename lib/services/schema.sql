-- SQL Schema untuk Project UTS Pemrograman Mobile
-- Nama Tabel: drink_logs
-- Primary Key: id
-- Fields: id, student_id, beverage_type, volume_ml, logged_at, note (≥ 4 field data)

CREATE TABLE IF NOT EXISTS drink_logs (
    id TEXT PRIMARY KEY,
    student_id TEXT,
    beverage_type TEXT NOT NULL,
    volume_ml INTEGER NOT NULL,
    logged_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    note TEXT
);

-- Row Level Security (RLS)
ALTER TABLE drink_logs ENABLE ROW LEVEL SECURITY;

-- Policy untuk read & write public anon
CREATE POLICY "Allow public read access" ON drink_logs FOR SELECT USING (true);
CREATE POLICY "Allow public insert access" ON drink_logs FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update access" ON drink_logs FOR UPDATE USING (true);
CREATE POLICY "Allow public delete access" ON drink_logs FOR DELETE USING (true);
