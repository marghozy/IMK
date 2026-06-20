import type { Lesson, LessonCard } from '@/types';

const MOCK_LESSONS: Lesson[] = [
  {
    id: 'nglegena',
    title: 'Nglegena Dasar',
    category: 'Aksara dasar',
    description: 'Aksara dasar · 20 huruf',
    icon: '𑆅',
    accentColor: 'primary',
    totalCharacters: 20,
    progress: 65,
    xpReward: 50,
    locked: false,
  },
  {
    id: 'sandhangan',
    title: 'Sandhangan',
    category: 'Tanda vokal',
    description: 'Tanda vokal · 8 aturan',
    icon: '𑇂',
    accentColor: 'blue',
    totalCharacters: 8,
    progress: 25,
    xpReward: 80,
    locked: false,
  },
  {
    id: 'pasangan',
    title: 'Pasangan',
    category: 'Konsonan ganda',
    description: 'Konsonan ganda · 20 huruf',
    icon: 'ꦗ',
    accentColor: 'purple',
    totalCharacters: 20,
    progress: 0,
    xpReward: 100,
    locked: false,
  },
  {
    id: 'aksara-wilangan',
    title: 'Aksara Wilangan',
    category: 'Angka',
    description: 'Angka · 10 simbol',
    icon: '꧐',
    accentColor: 'cream',
    totalCharacters: 10,
    progress: 0,
    xpReward: 60,
    locked: true,
  },
];

const MOCK_LESSON_CARDS: Record<string, LessonCard[]> = {
  pasangan: [
    {
      id: 'pasangan-na',
      lessonId: 'pasangan',
      index: 3,
      totalCards: 20,
      aksara: 'ꦤ꧀ + ꦢ = ꦢ꧀ꦤ',
      title: 'Pasangan Na',
      description: 'Mematikan vokal aksara di depannya. Ditulis di bawah aksara sebelumnya.',
      example: 'ꦱꦸꦫꦠ꧀ꦤ = surat-na',
      phoneme: '/n/',
      position: 'Bawah',
      warning: 'Pasangan hanya muncul setelah aksara berakhiran konsonan. Tidak bisa berdiri sendiri.',
    },
  ],
  sandhangan: [
    {
      id: 'sandhangan-wulu',
      lessonId: 'sandhangan',
      index: 2,
      totalCards: 8,
      aksara: 'ꦏꦶ',
      title: 'Wulu',
      description: 'Tanda vokal /i/ — ditulis di atas aksara',
      example: 'ꦏꦶꦠ = kita',
      phoneme: '/i/',
      position: 'Atas',
      tip: 'Wulu seperti titik air kecil yang menetes di atas aksara — bayangkan suara /i/ yang ringan.',
    },
  ],
};

export const lessonService = {
  getLessons: async (): Promise<Lesson[]> => MOCK_LESSONS,
  getLessonCards: async (lessonId: string): Promise<LessonCard[]> => MOCK_LESSON_CARDS[lessonId] ?? [],
};
