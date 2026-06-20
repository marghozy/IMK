import type { DailyAccuracy } from '@/types';

const MOCK_ACCURACY: DailyAccuracy[] = [
  { day: 'Sel', accuracy: 75 },
  { day: 'Rab', accuracy: 88 },
  { day: 'Kam', accuracy: 92 },
  { day: 'Jum', accuracy: 80 },
  { day: 'Sab', accuracy: 85 },
  { day: 'Min', accuracy: 90 },
  { day: 'Sen', accuracy: 84 },
];

export const progressService = {
  getWeeklyAccuracy: async (): Promise<DailyAccuracy[]> => MOCK_ACCURACY,
  getSummary: async () => ({
    totalXp: 1280,
    streakDays: 7,
    accuracy: 84,
    lessonsCompleted: 24,
    quizzesCompleted: 12,
  }),
};
