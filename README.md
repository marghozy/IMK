# JawaLingo

Aplikasi mobile-first untuk belajar Aksara Jawa, dibangun dengan React 18, TypeScript, Vite, dan Tailwind CSS.

## Menjalankan secara lokal

```bash
npm install
npm run dev
```

Buka `http://localhost:5173` di browser.

## Script

| Script | Deskripsi |
|---|---|
| `npm run dev` | Menjalankan dev server (Vite) |
| `npm run build` | Type-check + build production ke `dist/` |
| `npm run preview` | Preview hasil build production |
| `npm run lint` | Menjalankan ESLint |
| `npm run format` | Memformat kode dengan Prettier |

## Struktur Proyek

```
src/
├── assets/       # logo, ilustrasi, font
├── components/ui/ # komponen UI generik (Button, Input, Card, dst.)
├── features/      # komponen spesifik domain (auth, quiz, progress, dst.)
├── layouts/        # AuthLayout, OnboardingLayout, AppLayout
├── pages/           # 1 file per route
├── services/         # mock API layer per domain
├── hooks/             # custom hooks
├── utils/              # helper functions
├── types/               # tipe domain TypeScript
├── constants/             # route paths, nav items, config
├── routes/                 # definisi React Router
└── styles/                  # Tailwind & global CSS
```

## Konfigurasi

Salin `.env.example` ke `.env` jika ingin mengarahkan `apiClient` ke backend nyata:

```bash
cp .env.example .env
```

## Status

Saat ini seluruh halaman menggunakan mock service (`src/services/`) sehingga aplikasi bisa dijalankan tanpa backend.
