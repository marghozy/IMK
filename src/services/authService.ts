import type { User } from '@/types';

export interface LoginPayload {
  email: string;
  password: string;
}

export interface RegisterPayload {
  name: string;
  email: string;
  password: string;
}

export const authService = {
  login: async (_payload: LoginPayload): Promise<User> => {
    return {
      id: 'u1',
      name: 'Thariq Habibi',
      email: _payload.email,
      level: 5,
      xpTotal: 1200,
      streakDays: 7,
      membership: 'MEMBER',
    };
  },
  register: async (payload: RegisterPayload): Promise<User> => {
    return {
      id: 'u1',
      name: payload.name,
      email: payload.email,
      level: 1,
      xpTotal: 0,
      streakDays: 0,
      membership: 'FREE',
    };
  },
  requestPasswordReset: async (_email: string): Promise<{ sent: boolean }> => ({ sent: true }),
};
