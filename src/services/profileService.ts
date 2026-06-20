import type { Achievement, User } from '@/types';

const MOCK_USER: User = {
  id: 'u1',
  name: 'Thariq Habibi',
  email: 'thariq@example.com',
  level: 5,
  xpTotal: 1200,
  streakDays: 7,
  membership: 'MEMBER',
};

const MOCK_ACHIEVEMENTS: Achievement[] = [
  { id: 'a1', title: 'Pemula', icon: '🚀', dateLabel: 'Mei 1, 2026', locked: false },
  { id: 'a2', title: '7 Hari', icon: '🔥', dateLabel: 'Mei 7, 2026', locked: false },
  { id: 'a3', title: 'Akurat', icon: '🎯', dateLabel: 'Mei 5, 2026', locked: false },
  { id: 'a4', title: 'Master', icon: '👑', locked: true },
  { id: 'a5', title: 'Perfek', icon: '💎', locked: true },
  { id: 'a6', title: 'Kilat', icon: '⚡', locked: true },
];

export const profileService = {
  getCurrentUser: async (): Promise<User> => MOCK_USER,
  getAchievements: async (): Promise<Achievement[]> => MOCK_ACHIEVEMENTS,
};
