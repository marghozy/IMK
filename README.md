# JawaLingo (Flutter)

Aplikasi mobile belajar Aksara Jawa — dibangun dengan Flutter. Implementasi ini mencakup scope
**Tim A** sesuai prototype Figma.

## Tech Stack

- Flutter (stable) + Dart null-safety
- State management: `flutter_riverpod` (manual `Notifier`/`NotifierProvider`, tanpa codegen)
- Navigasi: `go_router`
- Font: `google_fonts` (Baloo 2 / Nunito untuk Latin, Noto Sans Javanese untuk aksara)
- Chart: `fl_chart` (akurasi 7 hari)
- Kalender: `table_calendar` (streak)
- Tracing aksara: `CustomPainter` + `GestureDetector` (tanpa package signature-pad eksternal)
- Data: mock/offline saja (tidak ada backend)

## Menjalankan

```bash
flutter pub get
flutter run
```

## Struktur

```
lib/
├── core/        # theme, router, widget bersama
├── data/        # models & mock data
└── features/    # 1 folder per domain (splash, onboarding, auth, home, learn, quiz, progress, profile, ...)
```

## Scope

**Tim A (lengkap & fungsional):** Splash, Onboarding, Register, Login, Pilih
Tujuan Harian, Home, Belajar/Lobi, Materi Pembelajaran, Latihan Menulis
Aksara, Kuis (pilih level, soal, feedback, hasil), Progress Dashboard,
Profile.
