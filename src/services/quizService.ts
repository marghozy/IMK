import type { QuizLevel, QuizLevelId, QuizQuestion, QuizSessionResult } from '@/types';

const MOCK_LEVELS: QuizLevel[] = [
  { id: 'pemula', title: 'Pemula', description: 'Nglegena dasar', icon: '🌱', bestScore: '8/10', starRating: 3, locked: false },
  { id: 'menengah', title: 'Menengah', description: 'Sandhangan + Wulu', icon: '🌿', bestScore: '6/10', starRating: 2, locked: false },
  { id: 'tantangan-waktu', title: 'Tantangan Waktu', description: '10 soal · 60 detik', icon: '⚡', bestScore: '4/10', starRating: 1, locked: false },
  { id: 'master', title: 'Master', description: 'Pasangan + campur', icon: '👑', bestScore: '—', starRating: 0, locked: true },
];

const MOCK_QUESTIONS: QuizQuestion[] = [
  {
    id: 'q1',
    aksara: 'ꦠ',
    correctAnswer: 'Ta',
    options: ['Ka', 'Ha', 'Ra', 'Ta'],
    explanation: 'Aksara ꦠ dibaca "Ta". Bentuknya mirip ekor melingkar di bawah — beda dengan ꦏ yang lebih tegak di kiri.',
  },
];

export const quizService = {
  getLevels: async (): Promise<QuizLevel[]> => MOCK_LEVELS,
  getQuestions: async (_levelId: QuizLevelId): Promise<QuizQuestion[]> => MOCK_QUESTIONS,
  submitSession: async (result: QuizSessionResult): Promise<QuizSessionResult> => result,
};
