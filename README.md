# HydroTrack 💧 - Aplikasi Pengingat & Pencatat Minum Air

> **Project Ujian Tengah Semester (UTS) Pemrograman Mobile**  
> Jurusan Teknik Informatika / Pendidikan Teknik Informatika  
> Universitas Pendidikan Ganesha (UNDIKSHA)

---

## 👤 Identitas Mahasiswa
- **Nama Lengkap** : Moch. Rafael Firzallah
- **NIM**          : 2415051083
- **Kelas**        : Pemrograman Mobile
- **Dosen Pengampu**: Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom
- **Teaching Assistant**: Made Yuda Sadewa, S.Pd.
- **Repository GitHub**: [uts_2415051083_MOCH-RAFAEL-FIRZALLAH](https://github.com/rafaelfirzallah-30/uts_2415051083_MOCH-RAFAEL-FIRZALLAH)

---

## 📱 Deskripsi Project
**HydroTrack** adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna menjaga hidrasi tubuh harian secara teratur. Aplikasi ini memungkinkan pengguna memantau progres konsumsi cairan harian terhadap target, mencatat konsumsi air dengan preset cepat maupun kustom slider, melihat riwayat minum dalam format responsif (List/Grid), serta memperoleh edukasi dan tips kesehatan terkini yang terhubung langsung dengan **REST API** dan database cloud **Supabase (PostgreSQL)**.

---

## ✨ Fitur Utama Aplikasi
1. **Dashboard Hidrasi Interaktif (Home Screen)**
   - Kartu progres konsumsi air real-time dengan status persentase dan sisa target harian.
   - Badge streak motivasi hidrasi harian.
   - Tombol sekali sentuh (*Quick Preset*) untuk volume 150ml, 250ml, 330ml, 500ml, dan 600ml.
   - Modal Bottom Sheet dengan slider volume interaktif untuk pencatatan cepat tanpa berpindah layar.
2. **Katalog & Riwayat Minum Responsif (Drink List Screen)**
   - Tampilan adaptif: **1-Column ListView** pada mode ponsel/compact, dan otomatis berubah menjadi **2-Column GridView** pada tablet/layar lebar.
   - Fitur pencarian (*Search Bar*) dan filter kategori minuman (*Air Mineral, Teh, Kopi, Jus Buah, Susu, dsb.*).
   - Fitur gesture **Swipe to Delete (Dismissible)** dengan dialog konfirmasi.
3. **Detail Catatan Minum (Drink Detail Screen)**
   - Menampilkan rincian tanggal, jam pencatatan, jenis minuman, volume, dan catatan tambahan.
   - Navigasi edit data dan hapus data dengan dialog konfirmasi aman.
4. **Form Tambah & Edit Catatan (CRUD)**
   - Validasi form ketat: volume wajib angka positif, rentang valid (1 - 5.000 ml).
   - Pemilih waktu interaktif (*TimePicker*).
   - Indikator proses simpan/update asinkron (*Loading State*).
5. **Tips & Edukasi Hidrasi (REST API Integration)**
   - Integrasi langsung dengan REST API publik (*Advice Slip API*).
   - Dilengkapi *Pull-to-Refresh* untuk memperbarui tips harian.
6. **Profil & Pengaturan Target (Profile Screen)**
   - Pengaturan target konsumsi air harian interaktif menggunakan dialog slider (1.000 - 4.000 ml).
   - Tampilan informasi mahasiswa dan status koneksi database.

---

## 🛠️ Tech Stack
- **Framework**       : Flutter (Material 3)
- **Programming Lang**: Dart (Null-safety)
- **State Management**: Provider (`ChangeNotifier`)
- **Backend Database**: Supabase (PostgreSQL) + Local Offline Cache
- **REST API Client** : `http`
- **Konfigurasi Aman**: `flutter_dotenv` (.env file diabaikan oleh Git)
- **Formatting**      : `intl` (Format tanggal & waktu lokal)

---

## 🌐 Integrasi REST API & Database

### 1. REST API
- **Endpoint**: `https://api.adviceslip.com/advice`
- **Metode HTTP**: `GET`
- **Model Dart**: `HydrationTip`
- **Status UI Terkelola**: Loading State, Error State (dengan tombol coba lagi), Empty State, dan Data State.

### 2. Backend Database (Supabase PostgreSQL)
- **Tabel**: `drink_logs`
- **Skema Kolom**:
  | Field | Tipe Data | Keterangan |
  | :--- | :--- | :--- |
  | `id` | `TEXT` | Primary Key |
  | `student_id` | `TEXT` | NIM / ID Pemilik |
  | `beverage_type` | `TEXT` | Jenis Minuman |
  | `volume_ml` | `INTEGER` | Volume Cairan (ml) |
  | `logged_at` | `TIMESTAMPTZ` | Timestamp Waktu Minum |
  | `note` | `TEXT` | Catatan Tambahan |
- **Operasi CRUD**:
  - **Create**: Tambah catatan dari Form & Quick Add.
  - **Read**: Mengambil seluruh riwayat konsumsi dari database.
  - **Update**: Memperbarui volume, jenis minuman, waktu, dan catatan.
  - **Delete**: Menghapus catatan dengan dialog konfirmasi wajib.

---

## 🏗️ Struktur Arsitektur Aplikasi
Mengikuti prinsip clean architecture standar penilaian UTS:  
`UI (Screens & Widgets) ➔ State Management (Provider) ➔ Repository ➔ Service / Data Source ➔ REST API / Supabase Database`

```text
lib/
├── core/
│   ├── app_constants.dart       # Konstanta target harian & kategori minuman
│   ├── app_feedback.dart        # Helper standar SnackBar & Confirmation Dialog
│   ├── app_theme.dart           # Konfigurasi Tema Material 3
│   └── responsive.dart          # Helper breakpoint Compact (<600dp) vs Wide (≥600dp)
├── models/
│   ├── drink_log.dart           # Model data catatan minum (CRUD Supabase)
│   └── hydration_tip.dart       # Model data tips dari REST API
├── services/
│   ├── api_service.dart         # HTTP Client untuk REST GET API
│   ├── database_service.dart    # Client Supabase & Offline-First Cache
│   └── schema.sql               # Skrip migrasi tabel PostgreSQL Supabase
├── repositories/
│   ├── drink_repository.dart    # Abstraksi data log riwayat minum
│   └── tip_repository.dart      # Abstraksi data tips hidrasi
├── providers/
│   ├── drink_provider.dart      # State management riwayat, filter, dan CRUD
│   └── tip_provider.dart        # State management data REST API (loading/error)
├── screens/
│   ├── main_screen.dart         # Root shell NavigationBar & NavigationRail
│   ├── home_screen.dart         # Dashboard progres hidrasi
│   ├── drink_list_screen.dart   # Riwayat minum responsif (List/Grid)
│   ├── drink_detail_screen.dart # Detail data log minum
│   ├── add_drink_screen.dart    # Form Create catatan minum
│   ├── edit_drink_screen.dart   # Form Update catatan minum
│   ├── tips_screen.dart         # Layar edukasi dari REST API
│   └── profile_screen.dart      # Profil mahasiswa & setting target slider
├── widgets/
│   ├── hydration_summary_card.dart  # Reusable widget statistik hidrasi
│   ├── quick_drink_button.dart      # Reusable widget tombol cepat ukuran gelas
│   ├── drink_item_tile.dart         # Reusable widget kartu item riwayat
│   ├── quick_add_sheet.dart         # Reusable modal slider catat cepat
│   └── state_handler_view.dart      # Reusable widget status loading, error, empty
└── main.dart                    # Entry point aplikasi & MultiProvider
```

---

## 🚀 Cara Menjalankan Project

1. **Clone Repositori**:
   ```bash
   git clone https://github.com/rafaelfirzallah-30/uts_2415051083_MOCH-RAFAEL-FIRZALLAH.git
   cd uts_2415051083_MOCH-RAFAEL-FIRZALLAH
   ```

2. **Konfigurasi Environment Variable (`.env`)**:
   Salin file `.env.example` menjadi `.env`:
   ```bash
   cp .env.example .env
   ```
   Buka file `.env` dan sesuaikan kredensial Supabase Anda:
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-publishable-key
   ```
   *(Catatan: Aplikasi tetap memiliki fallback lokal otomatis jika dijalankan tanpa koneksi Supabase).*

3. **Install Dependensi**:
   ```bash
   flutter pub get
   ```

4. **Jalankan Pengujian Unit & Widget**:
   ```bash
   flutter test
   ```

5. **Jalankan Aplikasi**:
   ```bash
   flutter run
   ```

---

## 📌 Riwayat 16 Milestone Git Commit
Sesuai ketentuan proses pengembangan bertahap pada dokumen UTS:

| No | Tahap / Milestone | Commit Message | Status |
| :---: | :--- | :--- | :---: |
| 1 | Project Initialization | `Commit Pertama` | ✅ |
| 2 | Architecture | `Setup project architecture and folders` | ✅ |
| 3 | Basic UI | `Build initial application UI` | ✅ |
| 4 | Responsive Layout | `Implement responsive layouts` | ✅ |
| 5 | Navigation | `Add application navigation` | ✅ |
| 6 | Models | `Add application data models` | ✅ |
| 7 | State Management | `Implement application state management` | ✅ |
| 8 | REST API | `Integrate REST API` | ✅ |
| 9 | Database | `Integrate backend database` | ✅ |
| 10 | Create | `Implement create data feature` | ✅ |
| 11 | Update | `Implement update data feature` | ✅ |
| 12 | Delete | `Implement delete data feature` | ✅ |
| 13 | Interaction | `Add interaction and user feedback` | ✅ |
| 14 | Error Handling | `Add loading and error handling` | ✅ |
| 15 | UI Refinement | `Improve UI and responsive behavior` | ✅ |
| **16** | **Final** | **`Finalize UTS mobile application`** | **Sekarang** |

---
*Dikembangkan dengan penuh dedikasi untuk Ujian Tengah Semester Pemrograman Mobile 2026.*
